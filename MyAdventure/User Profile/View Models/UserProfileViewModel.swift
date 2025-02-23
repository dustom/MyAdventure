//
//  UserProfileViewModel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.02.2025.


import Foundation
import SwiftData

@MainActor
class UserProfileViewModel: ObservableObject {
    private var savedUserProfile = [UserProfile]()
    var userProfile: UserProfile {
        guard !savedUserProfile.isEmpty else {
            return UserProfile(name: "Name", height: 180, weight: 70, birthdate: Date(), steps: 10000, calories: 400, activeMinutes: 60, imageData: nil)
        }
        return savedUserProfile.last!
    }
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        do {
            savedUserProfile = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch user settings:", error)
            savedUserProfile = [] // Set as empty array if fetch fails
        }
    }
}

extension String {
    func formattedWithSpaces() -> String {
        let cleanedString = self.replacingOccurrences(of: " ", with: "")
        let reversedString = String(cleanedString.reversed())
        var result = ""
        for (index, character) in reversedString.enumerated() {
            if index != 0 && index % 3 == 0 {
                result.append(" ")
            }
            result.append(character)
        }
        return String(result.reversed())
    }
}

