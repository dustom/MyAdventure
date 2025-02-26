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

    // is HealthKitInitialized makes shure that the fetch methods won't try do ask for data befere initialization
    private var isHealthKitInitialized = false
    private let healthStore = HKHealthStore()
    
    
    // method that handles any error that mgith occur while working with HealthStore
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
            
            // user can be easily led to setting where they can allow Health Data
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
    
    
    // method to initialize HealthKit capabilities
    func initializeHealthStore() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."])
        }
        
        // this set represents all items to be allowed
        let allTypes: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.height),
            HKQuantityType(.bodyMass),
            HKQuantityType(.stepCount)
        ]
        
        // ask user for Authorization
        do {
            try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
        } catch {
            throw NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to request HealthKit authorization: \(error.localizedDescription)"])
        }
    }
    

    
    // method that fetches all steps that were made that day
    func fetchTodaySteps() async throws -> Int {
        
        // make sure that HK was initialized
        if !isHealthKitInitialized {
                try await initializeHealthStore()
            }
        
        // create predicate for today and for desired data - steps
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        
        //check wheter user authorized the app to use HK data, otherwise show alert with the ability to go to settings
        let status = healthStore.authorizationStatus(for: steps)
        
        
        if status == .sharingAuthorized {
            return try await withCheckedThrowingContinuation { continuation in
               
                // try to fetch today's steps from HK
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
                    
                    //after the fetching from HK is done, return actual step count
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
    
    // method that fetches calories that were burned that day, works basically the same as fetchTodaySteps
    func fetchTodayCalories() async throws -> Int {
        
        if !isHealthKitInitialized {
                try await initializeHealthStore()
            }
        
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
    
    
    // method that fetches last week's workouts works basically the same as fetchTodaySteps and fetchTodayCalories but with different predicate
    func fetchLastWeekWorkouts() async throws -> [HKWorkout] {
        
        if !isHealthKitInitialized {
                try await initializeHealthStore()
            }
        
        let workoutType = HKWorkoutType.workoutType()
        
        
        // calculate what time it was one week ago
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
    
    
    
    //method that fetches all workouts stored in Health, works basically the same as the other fetch methods
    func fetchAllWorkouts() async throws -> [HKWorkout] {
        
        if !isHealthKitInitialized {
                try await initializeHealthStore()
            }
        
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
    
    
    // method that returns authorization status for given identifier, ie steps, activeEnergy etc.
    func checkAccess(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus {

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
