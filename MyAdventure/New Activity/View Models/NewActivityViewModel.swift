//
//  NewActivityViewModel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.02.2025.
//

import Foundation
import SwiftData

@MainActor
class NewActivityViewModel: ObservableObject {
    
    let userProfileVM: UserProfileViewModel
    let user: UserProfile
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        userProfileVM = UserProfileViewModel(modelContext: modelContext)
        user = userProfileVM.userProfile
    }
    
    
    // a simple method to calculate calories based on the user data
    func calculateCalories(activityDuration: Int, exertion: Int, user: UserProfile) -> Int {
        
        let caloriesBurned = (activityDuration*(exertion+3)*user.weight)/200
        
        return caloriesBurned
    }
    
    
    // method that edits the activity in SwiftData
    func editActivity(activity: Activity, name: String, activityType: ActivityType, activityDescription: String, durationHr: Int, durationMin: Int, distanceKm: Int, distanceM: Int, exertion: Int, selectedDate: Date) {
        
        let duration = Int(durationHr) * 60 + Int(durationMin)
        let distance = Double(distanceKm) + Double(distanceM) / 10
        
        activity.name = name
        activity.activityType = activityType.rawValue
        activity.activityDescription = activityDescription
        activity.duration = duration
        activity.distance = distance
        activity.exertion = exertion
        activity.date = selectedDate
        activity.caloriesBurned = calculateCalories(activityDuration: duration, exertion: exertion, user: self.user)
        
        saveContext()
    }
    
    
    //method that creates a new activity and saves it to SwiftData
    func addNewActivity(name: String, activityType: ActivityType, activityDescription: String, durationHr: Int, durationMin: Int, distanceKm: Int, distanceM: Int, exertion: Int, selectedDate: Date) {
        
        let duration = Int(durationHr) * 60 + Int(durationMin)
        let distance = Double(distanceKm) + Double(distanceM) / 10
        
        let newItem = Activity(
            name: name,
            activityType: activityType.rawValue,
            activityDescription: activityDescription,
            duration: duration,
            distance: distance,
            exertion: exertion,
            date: selectedDate,
            myActivity: true,
            caloriesBurned: calculateCalories(activityDuration: duration, exertion: exertion, user: user)
        )
        modelContext.insert(newItem)
        saveContext()
    }
    
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
