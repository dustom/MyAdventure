//
//  NewActivityViewModel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.02.2025.
//

import Foundation

@MainActor
class NewActivityViewModel: ObservableObject {
    
    func calculateCalories(activityDuration: Int, exertion: Int, user: UserProfile) -> Int {
        
        let caloriesBurned = (activityDuration*(exertion+2)*user.weight)/200
        
        return caloriesBurned
    }
    
}
