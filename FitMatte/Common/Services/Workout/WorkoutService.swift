//
//  WorkoutService.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import FirebaseFirestore

final class WorkoutService: WorkoutServiceProtocol {
    private let db = Firestore.firestore()
    private let workoutCollection = FirebaseCollection.workouts.rawValue
    private let userCollection = FirebaseCollection.users.rawValue

    func addProgram(_ program: WorkoutProgram, for userId: String) async throws {
        do {
            try db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("programs")
                .collection("list")
                .addDocument(from: program)
            print("[WorkoutService] Workour program saved for \(userId)")
        } catch {
            print("[WorkoutService] Failed to save workout program: \(error.localizedDescription)")
        }
    }

    func updateProgram(_ program: WorkoutProgram, for userId: String) async throws {
        do {
            guard let programId = program.id else {
                throw NSError(domain: "WorkoutService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Program ID is nil"])
            }

            try db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("programs")
                .collection("list")
                .document(programId)
                .setData(from: program, merge: true)

            print("[WorkoutService] Workout program \(programId) updated for user \(userId)")
        } catch {
            print("[WorkoutService] Failed to update workout program: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchPrograms(for userId: String) async throws -> [WorkoutProgram] {
        do {
            let snapshot = try await db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("programs")
                .collection("list")
                .order(by: "createdAt", descending: true)
                .getDocuments()
            let programs = try snapshot.documents.map { try $0.data(as: WorkoutProgram.self) }
            print("[WorkoutService] Fetched \(programs.count) workout programs for user \(userId)")
            return programs
        } catch {
            print("[WorkoutService] Failed to fetch workout programs: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteProgram(_ programId: String, for userId: String) async throws {
        do {
            try await db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("programs")
                .collection("list")
                .document(programId)
                .delete()
            print("[WorkoutService] Workout program \(programId) deleted for user \(userId)")
        } catch {
            print("[WorkoutService] Failed to delete workout program: \(error.localizedDescription)")
            throw error
        }
    }

    func saveWorkoutLog(_ log: WorkoutLog, for userId: String) async throws {
        let dateKey = log.date.formatAsKey()

        do {
            try db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("dailyLogs")
                .collection("list")
                .document(dateKey)
                .setData(from: log)
            print("[WorkoutService] Workout log saved for user \(userId) on \(dateKey)")

        } catch {
            print("[WorkoutService] Failed to save workout log: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchWorkoutLogs(for userId: String) async throws -> [WorkoutLog] {
        do {
            let snapshot = try await db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("dailyLogs")
                .collection("list")
                .order(by: "date", descending: true)
                .getDocuments()
            let logs = try snapshot.documents.map { try $0.data(as: WorkoutLog.self) }
            print("[WorkoutService] Fetched \(logs.count) workout logs for user \(userId)")
            return logs

        } catch {
            print("[WorkoutService] Failed to fetch workout logs: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteLog(_ log: WorkoutLog, for userId: String) async throws {
        do {
            try await db.collection(userCollection)
                .document(userId)
                .collection(workoutCollection)
                .document("dailyLogs")
                .collection("list")
                .document(log.date.formatAsKey())
                .delete()
            print("[WorkoutService] Deleted  workout log for user \(userId)")
        } catch {
            print("[WorkoutService] Failed to delete workout log: \(error.localizedDescription)")
            throw error
        }
    }
}
