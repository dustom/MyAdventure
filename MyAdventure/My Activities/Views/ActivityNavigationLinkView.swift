//
//  ActivityNavigationLinkView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI

struct ActivityNavigationLinkView: View {
    var activity: Activity
    var vm = ActivityViewModel()
    var body: some View {
        HStack {
            HStack {
                Image(systemName: vm.getActivityIcon(for: activity.activityType.lowercased()))
                    .font(.title)
                    .padding(.horizontal)
            }
            .frame(width: 50)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(activity.name)")
                            .font(.title3)
                    }
                    
                    HStack(spacing: 12) {
                        if activity.distance > 0 {
                            Text(String(format: "%.1f km", activity.distance))
                                .font(.caption)
                        }
                        
                        // Duration formatting (shows hours after 120+ minutes)
                        Text(vm.formatDuration(activity.duration))
                            .font(.caption)
                        
                        // Speed/Pace calculation
                        if activity.distance > 0 {
                            Text(vm.calculateRate(activity: activity))
                                .font(.caption)
                        }
                    }
                    
                    HStack {
                        Text("\(activity.date.formatted(date: .numeric, time: .omitted))")
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {

        ActivityNavigationLinkView(activity: Activity(name: "Cycling Tour", activityType: "Cycling", activityDescription: "A long cycling tour around the city", duration: 150, distance: 40.0, exertion: 8, date: Date().addingTimeInterval(-604800)))
        
}
