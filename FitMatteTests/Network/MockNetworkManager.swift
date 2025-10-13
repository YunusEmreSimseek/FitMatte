//
//  MockNetworkManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
@testable import FitMatte

final class MockNetworkManager: NetworkManagerProtocol {
    var successValue: (any Decodable & Sendable)?
    var failureError: NetworkError?

    func request<T>(endpoint: any Endpoint, decodeType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        if let error = failureError {
            completion(.failure(error))
            return
        }
        if let value = successValue as? T {
            completion(.success(value))
            return
        }
        completion(.failure(.unknown))
    }

    func requestAsync<T>(endpoint: any Endpoint, decodeType: T.Type) async -> Result<T, NetworkError> where T: Decodable, T: Sendable {
        if let error = failureError {
            return .failure(error)
        }
        if let value = successValue as? T {
            return .success(value)
        }
        return .failure(.unknown)
    }
}
