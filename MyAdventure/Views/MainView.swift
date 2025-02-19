//
//  ContentView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State var selectedTab = "Overview"
    var body: some View {
        
        TabView {
            ActivityOverviewView()
                .tag("Overview")
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Overview", systemImage: "heart.fill")
                        .foregroundStyle(.primary)
                }
            
            MyActivitiesView()
                .tag("Activities")
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Activities", systemImage: "figure.run")
                        .foregroundStyle(.primary)
                }
                .environmentObject(healthManager)
            UserProfileView()
                .tag("Profile")
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                        .foregroundStyle(.primary)
                }
        }
        .onAppear {
            Task {
                do {
                    try await healthManager.initializeHealthStore()
                } catch {
                    healthManager.handleHealthKitError(error)
                    print("Failed to initialize HealthKit: \(error.localizedDescription)")
                }
            }
        }
    }
        
}

#Preview {
    MainView()
        .environmentObject(HealthManager())
}
