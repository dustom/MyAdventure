//
//  MyAdventureApp.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI
import SwiftData

@main
struct MyAdventureApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Activity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                
        }
        .modelContainer(sharedModelContainer)
       
        
    }
}
