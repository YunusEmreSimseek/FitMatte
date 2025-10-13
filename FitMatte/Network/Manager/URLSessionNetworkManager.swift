//
//  URLSessionNetworkManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
import Foundation

final class URLSessionNetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) { self.session = session }
    
    func request<T>(endpoint: any Endpoint, decodeType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let urlRequest = buildURLRequest(from: endpoint)
        else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        completion(.failure(.requestFailed(description: error.localizedDescription)))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                        completion(.failure(.invalidResponse(statusCode: statusCode)))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(.unknown))
                        return
                    }

                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(.decodingError(description: error.localizedDescription)))
                    }
                }
                task.resume()
    }
    
    func requestAsync<T>(endpoint: any Endpoint, decodeType: T.Type) async -> Result<T, NetworkError> where T: Decodable & Sendable {
        guard let urlRequest = buildURLRequest(from: endpoint)
        else { return .failure(.invalidURL)}
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                return .failure(.invalidResponse(statusCode: statusCode))
            }
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch  {
            return .failure(.requestFailed(description: error.localizedDescription))
        }
    }
}

extension URLSessionNetworkManager {
    private func buildURLRequest(from endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.baseURL) else { return nil }
                urlComponents.path = endpoint.path
                
                if endpoint.method == .get, let parameters = endpoint.parameters as? [String: String] {
                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                }
                
                guard let url = urlComponents.url else { return nil }
                var request = URLRequest(url: url)
                request.httpMethod = endpoint.method.rawValue
                
                endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
                
                if (endpoint.method == .post || endpoint.method == .put),
                   case .jsonEncoding = endpoint.parameterEncoding,
                   let parameters = endpoint.parameters {
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    } catch {
                        return nil
                    }
                }

                return request
    }
}
    
