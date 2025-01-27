//
//  FilterOptions.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 27.01.2025.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    case all
    case distanceAscending
    case distanceDescending
    case durationAscending
    case durationDescending
    case dateAscending
    case dateDescending
    var id: Self { self }
    
    var label: String {
            switch self {
            case .all:
                return "All"
            case .distanceAscending, .distanceDescending:
                return "Distance"
            case .durationAscending, .durationDescending:
                return "Duration"
            case .dateAscending, .dateDescending:
                return "Date"
            }
        }
    
    var arrow: String {
            switch self {
            case .all:
                return ""
            case .distanceAscending, .durationAscending, .dateAscending:
                return "arrow.up"
            case .distanceDescending, .durationDescending, .dateDescending:
                return "arrow.down"
            }
        }
    
    
}
