//
//  NetworkManagerProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        decodeType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    @available(iOS 13.0, *)
    func requestAsync<T: Decodable & Sendable>(
        endpoint: Endpoint,
        decodeType: T.Type
    ) async -> Result<T, NetworkError>
}
