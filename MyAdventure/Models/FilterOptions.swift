//
//  FilterOptions.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 27.01.2025.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    case dateDescending
    case dateAscending
    case distanceDescending
    case distanceAscending
    case durationDescending
    case durationAscending

    var id: Self { self }
    
    var label: String {
            switch self {
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
            case .distanceAscending, .durationAscending, .dateAscending:
                return "arrow.up"
            case .distanceDescending, .durationDescending, .dateDescending:
                return "arrow.down"
            }
        }
    
    
}
