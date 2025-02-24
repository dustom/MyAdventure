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
    
    func calculateActiveMinutes(from activities: [Activity]) -> Int {
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
        
        let todayActivities = activities.filter { $0.date >= .startOfDay && $0.date <= Date() }
        
        for activity in todayActivities {
            activeMinutes += activity.duration
        }
        
        return activeMinutes
    }
    
    func fetchToadyCalories(from activities: [Activity]) -> Int {
        var calories: Int = 0
        let todayActivities = activities.filter { $0.date >= .startOfDay && $0.date <= Date() }
        for activity in todayActivities {
            calories += activity.caloriesBurned
            
        }
        return calories
    }
    
    
    func lastWeekMyActivities(from activities: [Activity]) -> [Activity] {
        if activities.count > 0 {
            let currentDate = Date()

            // Calculate the start of the last week (7 days ago)
            let calendar = Calendar.current
            guard let startOfLastWeek = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
                fatalError("Could not calculate the start of the last week")
            }

            // Filter the array to include only entries from the last week
            let lastWeekActivities = activities.filter { $0.date >= startOfLastWeek && $0.date <= currentDate }
            return lastWeekActivities
            
        } else{
            return []
        }
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
            myActivity: false,
            caloriesBurned: 0
        )
        return activity
    }
    
    
}
