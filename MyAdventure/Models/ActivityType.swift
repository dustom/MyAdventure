//
//  ActivityType.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//

import Foundation

enum ActivityType: String, CaseIterable, Identifiable {
    case running = "Running"
    case swimming = "Swimming"
    case hiking = "Hiking"
    case cycling = "Cycling"
    case other = "Other"
    var id: Self { self }
    
}
