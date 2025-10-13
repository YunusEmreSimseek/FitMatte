//
//  NetworkError.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(description: String)
    case invalidResponse(statusCode: Int)
    case decodingError(description: String)
    case unknown
}
