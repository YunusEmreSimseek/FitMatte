//
//  UserServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
protocol UserServiceProtocol {
    func createUser(user: UserModel) async throws
    
    func updateUser(user: UserModel) async throws
    
    func fetchUser(by uid: String) async throws -> UserModel
}
