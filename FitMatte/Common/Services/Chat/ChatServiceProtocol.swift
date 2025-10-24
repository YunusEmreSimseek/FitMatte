//
//  ChatServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//

protocol ChatServiceProtocol {
    func addChat(chat: ChatModel) async throws
    func fetchAllChats(for userId: String) async throws -> [ChatModel]
    func fetchChat(for chatId: String) async throws -> ChatModel?
    func updateChat(chat: ChatModel) async throws
}

extension ChatServiceProtocol {
    func createInitialChats(for userId: String) async throws {
        for model in AIModel.allCases {
            let initialChat = ChatModel(
                userId: userId,
                aiModel: model,
                messages: [.welcomeMessage]
            )
            try await addChat(chat: initialChat)
        }
    }
}
