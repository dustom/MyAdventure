//
//  DataState.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 18.02.2025.
//

import Foundation

enum DataState {
    case idle
    case loading
    case loaded
    case error(Error)
}
