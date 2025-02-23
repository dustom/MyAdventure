//
//  ActivityNavigationLinkViewModel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import Foundation
import HealthKit

class ActivityViewModel: ObservableObject {
    
    @Published var state: DataState = .idle
    @Published var allActivites: [Activity] = []
    private var manager = HealthManager()
    
     func formatDuration(_ minutes: Int) -> String {
        if minutes >= 120 {
            let hours = Double(minutes) / 60.0
            // Show as integer if whole number
            return hours.truncatingRemainder(dividingBy: 1) == 0 ?
                "\(Int(hours)) h" :
                String(format: "%.1f h", hours)
        }
        return "\(minutes) min"
    }
    
     func calculateRate(activity: Activity) -> String {
        guard activity.distance > 0 else { return "" }
        
        let type = activity.activityType.lowercased()
        let minutes = Double(activity.duration)
        let distance = activity.distance
        
         if distance > 0 && minutes > 0 {
             if ["running", "hiking"].contains(type) {
                 let paceMinutes = minutes / distance
                 let seconds = (paceMinutes.truncatingRemainder(dividingBy: 1) * 60).rounded()
                 return String(format: "%d:%02d min/km", Int(paceMinutes), Int(seconds))
             }
             else
             
             {
                 let hours = minutes / 60.0
                 let speed = distance / hours
                 return String(format: "%.1f km/h", speed)
             }
         } else {
             return ""
         }
    }
    
     func getActivityIcon(for activityType: String) -> String {
         switch activityType.lowercased() {
        case "running": return "figure.run"
        case "cycling": return "figure.outdoor.cycle"
        case "swimming": return "figure.pool.swim"
        case "hiking": return "figure.hiking"
        default: return "figure.walk"
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
    
    @MainActor func loadActivities() async {
        state = .loading // Set state to loading
        do {
            let workouts = try await manager.fetchAllWorkouts()
            allActivites = workouts.map { createActivity(from: $0) }
            state = .loaded // Set state to loaded
        } catch {
            state = .error(error) // Set state to error
            print("An error has occurred while loading activities: \(error.localizedDescription)")
            manager.handleHealthKitError(error)
        }
    }
    
}
