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
    
    @Published var fetchedActivities: [Activity] = []
    
    func initializeHealthStore() async {
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            let allTypes: Set = [
                HKQuantityType.workoutType(),
                HKQuantityType(.activeEnergyBurned),
                HKQuantityType(.distanceCycling),
                HKQuantityType(.distanceWalkingRunning),
                HKQuantityType(.heartRate),
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
    
    func fetchTodaySteps(){
        let healthStore = HKHealthStore()
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_, result, error in
            guard let result = result?.sumQuantity(), error == nil else {
                print("Failed to fetch steps: \(error?.localizedDescription ?? "No error description.")")
                return
            }
            let stepsCount = result.doubleValue(for: .count())
            print("Today's steps: \(Int(stepsCount))")
        }
        healthStore.execute(query)
    }
    
    func fetchLastWeekWorkouts(){
        let healthStore = HKHealthStore()
        let workoutType = HKWorkoutType.workoutType()
        
        // Define the predicate for the last week
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let predicate = HKQuery.predicateForSamples(
            withStart: oneWeekAgo,
            end: Date(),
            options: .strictStartDate
        )
        
        // Query workouts
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [.init(key: HKSampleSortIdentifierStartDate, ascending: false)]
        ) { _, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Process each workout
            for workout in workouts {
                DispatchQueue.main.async {
                    self.fetchedActivities.append(self.createActivity(from: workout))
                }
                
            }
        }
        
        healthStore.execute(query)

    }

    func createActivity(from healthWorkout: HKWorkout) -> Activity {
        let activityType = healthWorkout.workoutActivityType.name
        
        // 2. Duration (in seconds)
        let duration = Int(healthWorkout.duration/60)
        
        // 3. Distance (if available)
        let distanceInMeters = healthWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0.0
        let distanceInKilometers = distanceInMeters/1000
        
        let date = healthWorkout.startDate
        
        //TODO: could calculate exertion based on HR
        
        let activity = Activity(name: activityType, activityType: activityType, activityDescription: "", duration: duration, distance: distanceInKilometers, exertion: 0, date: date)
        return activity

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
