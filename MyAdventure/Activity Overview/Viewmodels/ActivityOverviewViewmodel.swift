//
//  ActivityOverviewViewmodel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 01.02.2025.
//

import Foundation
import HealthKit

class ActivityOverviewViewmodel: ObservableObject {
    @Published var lastWeekActivities: [Activity] = []
    @Published var state: DataState = .idle
    
    private var manager = HealthManager()
    
    @MainActor
    func loadActivities() async {
        state = .loading // Set state to loading
        do {
            let workouts = try await manager.fetchLastWeekWorkouts()
            lastWeekActivities = workouts.map { createActivity(from: $0) }
            state = .loaded // Set state to loaded
        } catch {
            state = .error(error) // Set state to error
            print("An error has occurred while loading activities: \(error.localizedDescription)")
            manager.handleHealthKitError(error)
        }
    }
    
    func calculateActiveMinutes() -> Int {
        var activeMinutes: Int = 0
        let calendar = Calendar.current
        
        // Get today's date components
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        for workout in lastWeekActivities {
            // Get the workout's date components
            let workoutComponents = calendar.dateComponents([.year, .month, .day], from: workout.date)
            
            // Compare the date components
            if workoutComponents == todayComponents {
                activeMinutes += workout.duration
            }
        }
        
        return activeMinutes
    }
    
    private func createActivity(from healthWorkout: HKWorkout) -> Activity {
        let activityType = healthWorkout.workoutActivityType.name
        
        // 2. Duration (in seconds)
        let duration = Int(healthWorkout.duration / 60)
        
        // 3. Distance (if available)
        let distanceInMeters = healthWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0.0
        let distanceInKilometers = distanceInMeters / 1000
        
        let date = healthWorkout.startDate
        
        //TODO: could calculate exertion based on HR
        
        let activity = Activity(
            name: activityType,
            activityType: activityType,
            activityDescription: "",
            duration: duration,
            distance: distanceInKilometers,
            exertion: 0,
            date: date,
            myActivity: false
        )
        return activity
    }
    
    
}
