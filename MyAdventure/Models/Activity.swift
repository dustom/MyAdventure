//
//  Item.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import Foundation
import SwiftData

@Model
final class Activity: Identifiable {
    var id: UUID = UUID()
    var name: String
    var activityType: String
    var activityDescription: String
    var duration: Int
    var distance: Double
    var exertion: Int
    var date: Date
    var myActivity: Bool
    
    init(name: String, activityType: String, activityDescription: String, duration: Int, distance: Double, exertion: Int, date: Date, myActivity: Bool) {
        self.name = name
        self.activityType = activityType
        self.activityDescription = activityDescription
        self.duration = duration
        self.distance = distance
        self.exertion = exertion
        self.date = date
        self.myActivity = myActivity
    
    }
}
