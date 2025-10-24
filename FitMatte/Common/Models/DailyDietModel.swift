//
//  DailyDietModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import FirebaseFirestore

struct DailyDietModel: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let dateString: String

    let stepCount: Int?
    let cardioMinutes: Int?
    let caloriesTaken: Int?

    let protein: Int?
    let carbs: Int?
    let fat: Int?

    let weight: Double?

    var note: String?
}

extension DailyDietModel {
    static let dummyLog1 = DailyDietModel(
        id: "1",
        dateString: "2025-04-30",
        stepCount: 10000,
        cardioMinutes: 30,
        caloriesTaken: 2000,
        protein: 150,
        carbs: 250,
        fat: 70,
        weight: 75.0,
        note: "Great day!"
    )
    static let dummyLog2 = DailyDietModel(
        id: "2",
        dateString: "2025-05-01",
        stepCount: 12000,
        cardioMinutes: 45,
        caloriesTaken: 2200,
        protein: 160,
        carbs: 260,
        fat: 80,
        weight: 74.5,
        note: "Feeling good!"
    )
    static let dummyLog3 = DailyDietModel(
        id: "3",
        dateString: "2025-05-02",
        stepCount: 8000,
        cardioMinutes: 20,
        caloriesTaken: 1800,
        protein: 140,
        carbs: 240,
        fat: 60,
        weight: 74.0,
        note: "Need to improve!"
    )
    static let dummyLog4 = DailyDietModel(
        id: "4",
        dateString: "2025-05-03",
        stepCount: 9000,
        cardioMinutes: 25,
        caloriesTaken: 1900,
        protein: 145,
        carbs: 245,
        fat: 65,
        weight: 73.5,
        note: "Almost there!"
    )
    static let dummyLogs: [Self] = [
        dummyLog1,
        dummyLog2,
        dummyLog3,
        dummyLog4,
    ]
    func dateFromString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
}
