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
    //TODO: if the user didnt allow Health Data usage, inform them in the profile section +
    // navigate them to the right place
    
    //TODO: try to set up anchor to fetch only new activities and not duplicates
    
    
    func initializeHealthStore() async {
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            let allTypes: Set = [
                HKQuantityType.workoutType(),
                HKQuantityType(.activeEnergyBurned),
                HKQuantityType(.height),
                HKQuantityType(.bodyMass),
                HKQuantityType(.stepCount)
            ]
            do {
                // Asynchronously request authorization to the data.
                try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
            } catch {
                
                fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
            }
            
        }
    }
    

    func fetchTodaySteps() async throws -> Int {
        let healthStore = HKHealthStore()
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result?.sumQuantity() else {
                    continuation.resume(throwing: NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "No step data available."]))
                    return
                }
                
                // 7. Return the step count
                let stepsCount = result.doubleValue(for: .count())
                continuation.resume(returning: Int(stepsCount))
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayCalories() async throws -> Int {
        let healthStore = HKHealthStore()
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
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
    }
    
    func fetchLastWeekWorkouts() async throws -> [HKWorkout] {
        let healthStore = HKHealthStore()
        let workoutType = HKWorkoutType.workoutType()
        
        // Calculate the date one week ago
        guard let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            throw NSError(domain: "DateCalculationError", code: -1, userInfo: nil)
        }
        
        // Define the predicate for the last week
        let predicate = HKQuery.predicateForSamples(
            withStart: oneWeekAgo,
            end: Date(),
            options: .strictStartDate
        )
        
        // Execute the query
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
    }
    
    func fetchTodayWorkouts() async throws -> [HKWorkout] {
        let healthStore = HKHealthStore()
        let workoutType = HKWorkoutType.workoutType()
        
        // Define the predicate for the last week
        let predicate = HKQuery.predicateForSamples(
            withStart: .startOfDay,
            end: Date(),
            options: .strictStartDate
        )
        
        // Execute the query
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
    }

}

extension Date {
    static var startOfDay : Date {
        Calendar.current.startOfDay(for: Date())
    }
}

// Helper to convert workoutActivityType to a readable name
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .walking: return "Hiking"
        // Add more cases as needed
        default: return "Other"
        }
    }
}
