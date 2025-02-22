//
//  UserProfile.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.02.2025.
//

import Foundation
import SwiftData

@Model
final class UserProfile: Identifiable {
    
    @Attribute(.unique) var name: String
    var height: Int
    var weight: Int
    var birthdate: Date
    var steps: Int
    var calories: Int
    var activeMinutes: Int
    
    init(name: String, height: Int, weight: Int, birthdate: Date, steps: Int, calories: Int, activeMinutes: Int) {
        self.name = name
        self.height = height
        self.weight = weight
        self.birthdate = birthdate
        self.steps = steps
        self.calories = calories
        self.activeMinutes = activeMinutes
    }
    
}
