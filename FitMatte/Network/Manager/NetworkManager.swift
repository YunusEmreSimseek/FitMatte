//
//  NetworkManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    func sendJsonRequest<T: Decodable>() async -> Result<T, Error> {
        .failure(NSError(domain: "Not implemented", code: -1, userInfo: nil))
    }

    func sendDataRequest() async -> Result<Data, Error> {
        .failure(NSError(domain: "Not implemented", code: -1, userInfo: nil))
    }
}

final class NetworkManager2 {
    func sendJsonRequest<T: Decodable>() async throws -> Result<T, any Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            return .failure(NSError(domain: "Not implemented", code: -1, userInfo: nil))
        }
        
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                return .failure(URLError(.badServerResponse))
            }
            guard let item = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(URLError(.badServerResponse))
            }
            return .success(item)
        } catch {
            return .failure(error)
        }
    }

    func sendDataRequest() async -> Result<Data, any Error> {
        .failure(NSError(domain: "Not implemented", code: -1, userInfo: nil))
    }
}
