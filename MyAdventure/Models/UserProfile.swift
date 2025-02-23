//
//  UserProfile.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.02.2025.
//

import Foundation
import SwiftData
import UIKit

@Model
final class UserProfile: Identifiable {
    
    @Attribute(.unique) var name: String
    var height: Int
    var weight: Int
    var birthdate: Date
    var steps: Int
    var calories: Int
    var activeMinutes: Int
    var imageData: Data?
    
    init(name: String, height: Int, weight: Int, birthdate: Date, steps: Int, calories: Int, activeMinutes: Int, imageData: Data?) {
        self.name = name
        self.height = height
        self.weight = weight
        self.birthdate = birthdate
        self.steps = steps
        self.calories = calories
        self.activeMinutes = activeMinutes
        self.imageData = imageData
    }
    
    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
    
}
