//
//  MainViewViewmodel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 31.01.2025.
//

import Foundation
import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    
    //TODO: try to set up anchor to fetch only new activities and not duplicates
    
    func handleHealthKitError(_ error: Error) {
        if let healthKitError = error as? HKError {
            switch healthKitError.code {
            case .errorAuthorizationDenied:
                // HealthKit access was denied by the user
                showAlert(
                    title: "HealthKit Access Denied",
                    message: "Please grant access to HealthKit in Settings to use this feature.",
                    openSettings: true
                )
            case .errorAuthorizationNotDetermined:
                // HealthKit authorization has not been requested yet
                showAlert(
                    title: "HealthKit Access Required",
                    message: "Please enable HealthKit access in Settings to use this feature.",
                    openSettings: true
                )
            case .errorHealthDataUnavailable:
                // HealthKit is not available on this device
                showAlert(
                    title: "HealthKit Unavailable",
                    message: "HealthKit is not supported on this device."
                )
            default:
                // Handle other HealthKit errors
                print("An unexpected HealthKit error occurred: \(error.localizedDescription)")
            }
        } else {
            // Handle non-HealthKit errors
            showAlert(
                title: "Error",
                message: "An unexpected error occurred: \(error.localizedDescription)"
            )
        }
    }
    
    // Helper function to show an alert
    func showAlert(title: String, message: String, openSettings: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if openSettings {
                alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                })
            }
            
            // Present the alert
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true)
            }
        }
    }
    
    func initializeHealthStore() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."])
        }
        
        let healthStore = HKHealthStore()
        let allTypes: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.height),
            HKQuantityType(.bodyMass),
            HKQuantityType(.stepCount)
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
        } catch {
            throw NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to request HealthKit authorization: \(error.localizedDescription)"])
        }
    }
    
    
    func fetchTodaySteps() async throws -> Int {
        let healthStore = HKHealthStore()
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        
        let status = healthStore.authorizationStatus(for: steps)
        
        if status == .sharingAuthorized {
            
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
                    if let error = error {
                        continuation.resume(throwing: NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch step count: \(error.localizedDescription)"]))
                        self.handleHealthKitError(error)
                        return
                    }
                    
                    guard let result = result?.sumQuantity() else {
                        continuation.resume(throwing: NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "No step data available for today."]))
                        return
                    }
                    
                    let stepsCount = result.doubleValue(for: .count())
                    continuation.resume(returning: Int(stepsCount))
                }
                
                healthStore.execute(query)
            }
        } else {
            showAlert(title: "No Authorization.", message: "You need to grant permission to access your step count.", openSettings: true)
            return 0
        }
    }
    
    func fetchTodayCalories() async throws -> Int {
        let healthStore = HKHealthStore()
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let status = healthStore.authorizationStatus(for: calories)
        
        if status == .sharingAuthorized {
            
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
                    if let error = error {
                        continuation.resume(throwing: NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch calories count: \(error.localizedDescription)"]))
                        self.handleHealthKitError(error)
                        return
                    }
                    
                    guard let result = result?.sumQuantity() else {
                        continuation.resume(throwing: NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "No step data available."]))
                        return
                    }
                    
                    let calories = result.doubleValue(for: .smallCalorie())
                    continuation.resume(returning: Int(calories/1000))
                }
                
                healthStore.execute(query)
            }
        } else {
            showAlert(title: "No Authorization.", message: "You need to grant permission to access your calories count.", openSettings: true)
            return 0
        }
    }
    
    func fetchLastWeekWorkouts() async throws -> [HKWorkout] {
        let healthStore = HKHealthStore()
        let workoutType = HKWorkoutType.workoutType()
        
        
        guard let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            throw NSError(domain: "DateCalculationError", code: -1, userInfo: nil)
        }
        
        
        let predicate = HKQuery.predicateForSamples(
            withStart: oneWeekAgo,
            end: Date(),
            options: .strictStartDate
        )
        
        let status = healthStore.authorizationStatus(for: workoutType)
        
        if status == .sharingAuthorized {
            
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: workoutType,
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let workouts = samples as? [HKWorkout] ?? []
                    continuation.resume(returning: workouts)
                }
                healthStore.execute(query)
            }
        } else {
            showAlert(title: "No Authorization.", message: "You need to grant permission to access your workouts.", openSettings: true)
            return []
        }
    }
    
    func fetchAllWorkouts() async throws -> [HKWorkout] {
        let healthStore = HKHealthStore()
        let workoutType = HKWorkoutType.workoutType()
        
        let predicate = HKQuery.predicateForSamples(
            withStart: .distantPast,
            end: Date(),
            options: .strictStartDate
        )
        
        let status = healthStore.authorizationStatus(for: workoutType)
        
        if status == .sharingAuthorized {
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: workoutType,
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let workouts = samples as? [HKWorkout] ?? []
                    continuation.resume(returning: workouts)
                }
                healthStore.execute(query)
            }
        } else {
            showAlert(title: "No Authorization.", message: "You need to grant permission to access your workouts.", openSettings: true)
            return []
        }
        
    }
    
    func checkAccess(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus {
        let healthStore = HKHealthStore()
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return .notDetermined
        }
        
        return healthStore.authorizationStatus(for: quantityType)
    }
}

extension Date {
    static var startOfDay : Date {
        Calendar.current.startOfDay(for: Date())
    }
}

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .walking: return "Hiking"
        default: return "Other"
        }
    }
}
