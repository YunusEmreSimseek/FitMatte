//
//  NetworkManagerProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Foundation

protocol NetworkManagerProtocol {
    func sendJsonRequest<T: Decodable>() async -> Result<T, Error>
    func sendDataRequest() async -> Result<Data, Error>
}
