//
//  ChatViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import Foundation

final class ChatViewModel: BaseViewModel {
    private let chatService: ChatServiceProtocol
    private let userSessionManager: UserSessionManager
    private let aiService: AIServiceProtocol
    var chat: ChatModel?
    var selectedAIModel: AIModel = .openAI
    var suggestion: Suggestion?
    
    init(
        chatService: ChatServiceProtocol = AppContainer.shared.chatService,
        userSessionManager: UserSessionManager = AppContainer.shared.userSessionManager,
        aiService: AIServiceProtocol = AppContainer.shared.aiService
    ) {
        self.chatService = chatService
        self.userSessionManager = userSessionManager
        self.aiService = aiService
    }
    
    func loadChat() async {
        if AppMode.isPreview {
            chat = ChatModel.dummyChat
            chat?.messages.append(.exampleAIMessage)
            chat?.messages.append(.exampleUserMessage)
            chat?.messages.append(.exampleUserMessage)
            chat?.messages.append(.exampleAIMessage)
            suggestion = .dummy
        } else {
            guard let uid = userSessionManager.currentUser?.id else { return }
            let chatId = "\(uid)_\(selectedAIModel.rawValue)"
            let fetchedChat = try? await chatService.fetchChat(for: chatId)
            chat = fetchedChat
            print("Chat loaded: \(String(describing: fetchedChat))")
        }
    }
    
    func addUserMessage(_ text: String) -> Bool {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard chat != nil else { return false }
        if AppMode.isPreview {
            chat!.messages.append(MessageModel(role: .user, text: text))
            chat!.messages.append(MessageModel(role: .assistant, text: "This is a preview AI response to your message: \(text)"))
            return false
        }
        
        let message = MessageModel(role: .user, text: text)
        chat!.addMessage(message)
        return true
    }
    
    func sendMessage(_ text: String) async {
        var aiReply = ""
        setState(.loading)
        defer { setState(.loaded) }
        do {
            let result = try await aiService.sendMessage(chat!.messages)
            if let suggestion = result.suggestion { self.suggestion = suggestion }
            aiReply = result.answer
            let aiMessage = MessageModel(role: .assistant, text: aiReply)
            chat!.addMessage(aiMessage)
            await saveChat(chat!)
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    func deleteChat() async {
        guard chat != nil else { return }
        chat!.messages.removeAll()
        chat!.messages.append(.welcomeMessage)
        setState(.loading)
        defer { setState(.loaded) }
        do {
            try await chatService.updateChat(chat: chat!)
        } catch {
            print("Error deleting chat messages: \(error)")
        }
    }
}

extension ChatViewModel {
    private func saveChat(_ chat: ChatModel) async {
        do {
            try await chatService.addChat(chat: chat)
        } catch {
            print("Error saving chat: \(error)")
        }
    }
}
