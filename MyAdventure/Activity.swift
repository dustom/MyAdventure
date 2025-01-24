//
//  Item.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import Foundation
import SwiftData

@Model
final class Activity {
    var name: String
    var activityType: String
    var activityDescription: String
    var duration: Int
    var distance: Double
    var exertion: Int
    
    init(name: String, activityType: String, activityDescription: String, duration: Int, distance: Double, exertion: Int) {
        self.name = name
        self.activityType = activityType
        self.activityDescription = activityDescription
        self.duration = duration
        self.distance = distance
        self.exertion = exertion
    }
    
}
