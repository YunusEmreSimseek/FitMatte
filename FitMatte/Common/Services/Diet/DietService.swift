//
//  DietService.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import FirebaseFirestore

final class DietService: DietServiceProtocol {
    private let db = Firestore.firestore()
    private let dietCollection = FirebaseCollection.diets.rawValue
    private let userCollection = FirebaseCollection.users.rawValue

    func saveDiet(_ diet: DietModel, for userId: String) async {
        do {
            try db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("activePlan")
                .setData(from: diet)
            print("[DietService] Diet plan saved for \(userId)")
        } catch {
            print("[DietService] Failed to save diet plan: \(error.localizedDescription)")
        }
    }

    func fetchDiet(for userId: String) async -> DietModel? {
        do {
            let snapshot = try await db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("activePlan")
                .getDocument()
            print("[DietService] Diet plan fetched successfully for \(userId)")
            return try snapshot.data(as: DietModel.self)
        } catch {
            print("[DietService] Failed to fetch diet plan: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteDiet(for userId: String) async {
        do {
            try await db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("activePlan")
                .delete()
            print("[DietService] Diet plan deleted successfully for \(userId)")
        } catch {
            print("[DietService] Failed to delete diet plan: \(error.localizedDescription)")
        }
    }

    func saveOrUpdateDailyDietLog(_ log: DailyDietModel, for userId: String) async {
        do {
            try db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("dailyLogs")
                .collection("list")
                .document(log.dateString)
                .setData(from: log, merge: true)

            print("[DietService] Daily Diet log saved succesfully for \(log.dateString)")
        } catch {
            print("[DietService] Daily Diet log Failed to save : \(error.localizedDescription)")
        }
    }

    func fetchDailyDietLogs(for userId: String, lastDays: Int = 7) async -> [DailyDietModel] {
        do {
            let snapshot = try await db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("dailyLogs")
                .collection("list")
                .order(by: "dateString", descending: true)
                .limit(to: lastDays)
                .getDocuments()
            print("[DietService] Daily Diet logs fetched successfully for \(userId)")
            return snapshot.documents.compactMap {
                try? $0.data(as: DailyDietModel.self)
            }
        } catch {
            print("[DietService] Daily Diet logs fetch failed: \(error.localizedDescription)")
            return []
        }
    }

    func deleteDailyDietLog(for userId: String, dateString: String) async {
        do {
            try await db.collection(userCollection)
                .document(userId)
                .collection(dietCollection)
                .document("dailyLogs")
                .collection("list")
                .document(dateString)
                .delete()
            print("[DietService] Daily Diet log deleted successfully for \(dateString)")
        } catch {
            print("[DietService] Daily Diet log deletion failed: \(error.localizedDescription)")
        }
    }
}
