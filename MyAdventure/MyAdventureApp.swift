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
    @StateObject var healthManager = HealthManager()
    
    // swift data calculated property, the schema holds two data types needed for storage
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Activity.self,
            UserProfile.self
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
        //singletons for model container and healthmanager to be used through the whole app
        .modelContainer(sharedModelContainer)
        .environmentObject(healthManager)
       
        
    }
}
