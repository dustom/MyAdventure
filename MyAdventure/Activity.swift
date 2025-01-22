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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
