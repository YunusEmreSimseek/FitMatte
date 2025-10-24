//
//  HealthDataService.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import FirebaseFirestore

protocol HealthDataServiceProtocol {
    func saveHealthData()
}
    

final class HealthDataService: HealthDataServiceProtocol {
    let db: Firestore = .firestore()
    var collection: FirebaseCollection = .healths
    
    func saveHealthData() { }
}
