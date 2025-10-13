//
//  NetworkService.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
@testable import FitMatte

final class TestUserService {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchUser(completion: @escaping (Result<TestUser, NetworkError>) -> Void) {
        networkManager.request(endpoint: TestEndpoint(), decodeType: TestUser.self, completion: completion)
    }

    @available(iOS 13.0, *)
    func fetchUserAsync() async -> Result<TestUser, NetworkError> {
        await networkManager.requestAsync(endpoint: TestEndpoint(), decodeType: TestUser.self)
    }
}
