//
//  UserService.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import FirebaseFirestore

final class UserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    private let usersCollection = FirebaseCollection.users.rawValue

    func createUser(user: UserModel) async throws {
        guard let uid = user.id else {
            throw UserServiceError.invalidUserID
        }
        do {
            try db.collection(usersCollection).document(uid).setData(from: user)
        } catch {
            throw UserServiceError.unknownError(error)
        }
    }

    func updateUser(user: UserModel) async throws {
        guard let uid = user.id else {
            throw UserServiceError.invalidUserID
        }
        do {
            try db.collection(usersCollection).document(uid).setData(from: user, merge: true)
        } catch {
            throw UserServiceError.unknownError(error)
        }
    }

    func fetchUser(by uid: String) async throws -> UserModel {
        do {
            let snapshot = try await db.collection(usersCollection).document(uid).getDocument()
            guard snapshot.exists else {
                throw UserServiceError.userNotFound
            }
            guard let user = try? snapshot.data(as: UserModel.self) else {
                throw UserServiceError.parsingError
            }
            return user
        } catch {
            throw UserServiceError.unknownError(error)
        }
    }
}
