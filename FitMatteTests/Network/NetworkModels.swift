//
//  NetworkModels.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
@testable import FitMatte

struct TestUser: Decodable, Equatable, Sendable {
    let id: Int
    let name: String
    let email: String
}

struct TestEndpoint: Endpoint {
    var baseURL: String { return "" }
    var path: String { return "" }
    var method: HTTPMethod { return .get }
    var headers: [String: String]? { return nil }
    var parameters: [String: Any]? { return nil }
    var parameterEncoding: ParameterEncoding { return .urlEncoding }
}
