//
//  NetworkTest.swift
//  FitMatteTests
//
//  Created by Emre Simsek on 13.10.2025.
//

@testable import FitMatte
import XCTest

final class NetworkTest: XCTestCase {
    var networkManager: MockNetworkManager!
    var service: TestUserService!

    override func setUpWithError() throws {
        super.setUp()
        networkManager = MockNetworkManager()
        service = TestUserService(networkManager: networkManager)
    }

    override func tearDownWithError() throws {
        networkManager = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccessCompletionHandler() {
        let expectedUser = TestUser(id: 1, name: "Test User", email: "test@test.com")
        networkManager.successValue = expectedUser
        networkManager.failureError = nil
        
        let expectation = XCTestExpectation(description: "Fetch user success with completion handler")
        
        service.fetchUser { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user, expectedUser, "Fetched user should match expected user")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUserFailureCompletionHandler() {
        let expectedError: NetworkError = .invalidResponse(statusCode: 404)
        networkManager.successValue = nil
        networkManager.failureError = expectedError
        
        let expectation = XCTestExpectation(description: "Fetch user failure with completion handler")
        
        service.fetchUser { result in
            switch result {
            case .success(let user):
                XCTFail("Expected failure but got success with user: \(user)")
            case .failure(let error):
                XCTAssertEqual(error, expectedError, "Error should match expected error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUserSuccessAsync() async {
        let expectedUser = TestUser(id: 1, name: "Test User", email: "test@test.com")
        networkManager.successValue = expectedUser
        networkManager.failureError = nil
        
        let expectation = XCTestExpectation(description: "Fetch user success with async/await")
        
        let result = await service.fetchUserAsync()
        switch result {
        case .success(let user):
            XCTAssertEqual(user, expectedUser, "Fetched user should match expected user")
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
        expectation.fulfill()
    }
    
    func testFetchUserFailureAsync() async {
        let expectedError: NetworkError = .invalidResponse(statusCode: 404)
        networkManager.successValue = nil
        networkManager.failureError = expectedError
        
        let expectation = XCTestExpectation(description: "Fetch user failure with async/await")
        
        let result = await service.fetchUserAsync()
        
        switch result {
        case .success(let user):
            XCTFail("Expected failure but got success with user: \(user)")
        case .failure(let error):
            XCTAssertEqual(error, expectedError, "Error should match expected error")
        }
        expectation.fulfill()
    }
}
