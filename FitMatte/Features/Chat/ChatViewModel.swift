//
//  ChatViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//

final class ChatViewModel: BaseViewModel {
    private let chatService: ChatServiceProtocol
    private let userSessionManager: UserSessionManager
    var chat: ChatModel?
    var selectedAIModel: AIModel = .openAI
    
    init(
        chatService: ChatServiceProtocol = AppContainer.shared.chatService,
        userSessionManager: UserSessionManager = AppContainer.shared.userSessionManager
    ) {
        self.chatService = chatService
        self.userSessionManager = userSessionManager
    }
    
    func loadChat() async {
        if AppMode.isPreview {
            self.chat = ChatModel.dummyChat
        }
        else {
            guard let uid = userSessionManager.currentUser?.id else { return }
            let chatId = "\(uid)_\(selectedAIModel.rawValue)"
            let fetchedChat = try? await chatService.fetchChat(for: chatId)
            self.chat = fetchedChat
            print("Chat loaded: \(String(describing: fetchedChat))")
        }
    }
}
