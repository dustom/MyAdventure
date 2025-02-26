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
    
    // computed property that either return user profile from SwiftData (if there is any) or returns default user
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
    
    
    //method that tries to fetch current user from SwiftData, if it fails, it gives empty user which is then taken care of in userProfile variable
    private func fetchUserProfile() {
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        do {
            savedUserProfile = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch user settings:", error)
            savedUserProfile = []
        }
    }
    
    
    // method that inserts current user profile to memory + immediately saves it to SwiftData, this way the app doesn't need to worry abou being in the background
    func saveUserProfile(activeHours: Int, activeMinutes: Int, userName: String, height: Int, weight: Int, birthdate: Date, steps: Int, activeEnergy: Int, userImageData: Data?) {
        let activeTime = (activeHours * 60) + activeMinutes*10
        let updatedUser = UserProfile(
            name: userName,
            height: height,
            weight: weight,
            birthdate: birthdate,
            steps: steps,
            calories: activeEnergy,
            activeMinutes: activeTime,
            imageData: userImageData)
        
        modelContext.insert(updatedUser)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
    
}

// just a simple extension that provides formatting to strings displaying numbers greater than 1000
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

