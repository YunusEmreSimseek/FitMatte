//
//  OpenAIService.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import Foundation
import OpenAI

final class OpenAIService: AIServiceProtocol {
    private let openAI: OpenAI
    
    init() {
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            self.openAI = .init(apiToken: "")
            fatalError("OpenAI API Key is missing in Info.plist")
        }
        self.openAI = .init(apiToken: apiKey)
    }
    
    func sendMessage(_ messages: [MessageModel]) async throws -> SuggestionPayload {
        let query = ChatQuery(
            messages: convertMessages(messages),
            model: .gpt4_o,
            maxCompletionTokens: 1000,
            temperature: 0.2
        )
        let result = try await openAI.chats(query: query)
        guard let content = result.choices.first?.message.content else {
            return SuggestionPayload(answer: "No response from AI", suggestion: nil)
        }
        print("-----------Content: \(content)")
               let suggestion: SuggestionPayload = parseJsonResponse(content)
               return suggestion
    }
}

extension OpenAIService {
    private func convertMessages(_ messages: [MessageModel]) -> [ChatQuery.ChatCompletionMessageParam] {
        let prompt = OpenAIPromts.buildSystemPromptWithUser()
        var chatMessages: [ChatQuery.ChatCompletionMessageParam] = [.developer(.init(content: .textContent(prompt)))]
        let lastMessages = messages.suffix(5)
        for message in lastMessages {
            let role: ChatQuery.ChatCompletionMessageParam.Role = message.role.rawValue == "user" ? .user : .assistant
            let content = message.text
            let messageParam = ChatQuery.ChatCompletionMessageParam(role: role, content: content)
            chatMessages.append(messageParam!)
        }
        return chatMessages
    }
    
    private func parseJsonResponse(_ content: String) -> SuggestionPayload {
           guard let start = content.range(of: "```json")?.upperBound,
                 let end = content.range(of: "```", range: start ..< content.endIndex)?.lowerBound else
           {
               print("Kod bloğu bulunamadı")
               return SuggestionPayload(answer: "No response from AI", suggestion: nil)
           }

           let jsonText = content[start ..< end].trimmingCharacters(in: .whitespacesAndNewlines)

           do {
               let data = Data(jsonText.utf8)
               let decoder = JSONDecoder()
               let suggestion = try decoder.decode(SuggestionPayload.self, from: data)
               print("✅ Answer:", suggestion.answer)
               print("💡 Suggestion:", suggestion.suggestion ?? "No suggestion")
               return suggestion
           } catch {
               print("❌ JSON ayrıştırılamadı:", error)
               return SuggestionPayload(answer: "No response from AI", suggestion: nil)
           }
       }
}
