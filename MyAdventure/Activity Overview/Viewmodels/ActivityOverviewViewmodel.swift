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
    // method that loads all HKworkouts and also controls the view's state
    func loadActivities() async {
        state = .loading
        do {
            let workouts = try await manager.fetchLastWeekWorkouts()
            lastWeekActivities = workouts.map { createActivity(from: $0) }
            state = .loaded
        } catch {
            state = .error(error)
            print("An error has occurred while loading activities: \(error.localizedDescription)")
            manager.handleHealthKitError(error)
        }
    }
    
    //method that calculates active minutes from user activities
    func calculateActiveMinutes(from activities: [Activity]) -> Int {
        var activeMinutes: Int = 0
        let calendar = Calendar.current
        
       
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        for workout in lastWeekActivities {
           
            let workoutComponents = calendar.dateComponents([.year, .month, .day], from: workout.date)
            
         
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
    
    //method that calculates all colories from user activities
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

            // calculate the start of the last week (7 days ago)
            let calendar = Calendar.current
            guard let startOfLastWeek = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
                fatalError("Could not calculate the start of the last week")
            }

            // filter the array to include only entries from the last week
            let lastWeekActivities = activities.filter { $0.date >= startOfLastWeek && $0.date <= currentDate }
            return lastWeekActivities
            
        } else{
            return []
        }
    }
    
    
    // method that creates an Activity data typpe object form HKWorkout
    private func createActivity(from healthWorkout: HKWorkout) -> Activity {
        let activityType = healthWorkout.workoutActivityType.name
        
        let duration = Int(healthWorkout.duration / 60)
        
        let distanceInMeters = healthWorkout.totalDistance?.doubleValue(for: .meter()) ?? 0.0
        let distanceInKilometers = distanceInMeters / 1000
        
        let date = healthWorkout.startDate
        
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
