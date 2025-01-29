//
//  ContentView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ActivityOverviewView()
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Overview", systemImage: "heart.fill")
                        .foregroundStyle(.primary)
                }
            
            MyActivitiesView()
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Activities", systemImage: "figure.run")
                        .foregroundStyle(.primary)
                }
            UserProfileView()
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                        .foregroundStyle(.primary)
                }
        }
        
    }
}

#Preview {
    MainView()
}
