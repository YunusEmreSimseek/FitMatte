//
//  ChatModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import FirebaseFirestore
import Foundation

struct ChatModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var aiModel: AIModel
    var messages: [MessageModel]

    init(userId: String, aiModel: AIModel, messages: [MessageModel]) {
        self.userId = userId
        self.messages = messages
        self.aiModel = aiModel
    }

    init(userId: String, aiModel: AIModel) {
        self.userId = userId
        self.aiModel = aiModel
        messages = [
            .welcomeMessage,
        ]
    }

    mutating func addMessage(_ message: MessageModel) {
        messages.append(message)
    }
}

extension ChatModel {
    var chatId: String {
        "\(userId)_\(aiModel.rawValue)"
    }
}

struct MessageModel: Codable, Identifiable {
    var id = UUID()
    var role: ChatRole
    var text: String
    var imageUrl: String?
    var createdAt: Date = .init()
}

enum ChatRole: String, Codable {
    case user
    case assistant
    case system
}

extension ChatModel {
    static let dummyChat: Self = .init(
        userId: "user1",
        aiModel: .mistralAI,
        messages: [
            .systemMessage,
            .welcomeMessage,
            .exampleUserMessage,
            .exampleAIMessage,
            .exampleUserMessage2,
        ]
    )
    static let dummyChat2: Self = .init(
        userId: "user2",
        aiModel: .openAI,
        messages: [
            .systemMessage,
            .welcomeMessage,
        ]
    )
    static let dummyChat3: Self = .init(
        userId: "user1",
        aiModel: .openAI,
        messages: [
            .systemMessage,
            .welcomeMessage,
            .exampleUserMessage,
        ]
    )
}

extension MessageModel {
    static let systemMessage: Self = .init(
        role: .system,
        text: "You are an AI fitness trainer. Give users short, motivating, simple and descriptive answers. Avoid unnecessary conversations."
    )
    static let welcomeMessage: Self = .init(
        role: .assistant,
        text: "Welcome to FitMate! I'm here to help you with your fitness journey. How can I assist you today?"
    )
    static let exampleUserMessage: Self = .init(
        role: .user,
        text: "Hi there! I need help with my workout plan."
    )
    static let exampleAIMessage: Self = .init(
        role: .assistant,
        text: "Sure! What are your fitness goals?"
    )
    static let exampleUserMessage2: Self = .init(
        role: .user,
        text: "Building muscles"
    )
    static let exampleMessages: [Self] = [
        .welcomeMessage,
        .exampleUserMessage,
        .exampleAIMessage,
        .exampleUserMessage2,
        .exampleUserMessage2,
        .exampleUserMessage2,
        .exampleUserMessage2,
        .exampleUserMessage2,
        .exampleUserMessage2,
        .exampleUserMessage2,
//        .exampleImageMessage,
    ]
    static let exampleImageMessage: Self = .init(role: .user, text: "Bu resimi analiz edip hangi makine olduğunu ve hangi kasları çalıştırdığını söyler misin ?", imageUrl: "https://firebasestorage.googleapis.com/v0/b/fitmate-f5315.firebasestorage.app/o/chat_images%2F33405E41-AA6A-4507-A427-92F27541A993.jpg?alt=media&token=94faf7aa-09ee-4d08-834a-d58df9d2d0d0")
}
