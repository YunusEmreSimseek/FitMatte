//
//  NetworkEndpoint.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
}
