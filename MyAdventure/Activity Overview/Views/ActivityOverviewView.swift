//
//  ActivityOverviewView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI
import SwiftData

struct ActivityOverviewView: View {
    @EnvironmentObject var manager: HealthManager
        @Query private var activities: [Activity]
    
//    private var activities: [Activity] = [
//        Activity(name: "Morning Run", activityType: "Running", activityDescription: "A short morning jog", duration: 30, distance: 5.0, exertion: 6, date: Date()),
//        Activity(name: "Afternoon Cycling", activityType: "Cycling", activityDescription: "Cycling through the park", duration: 45, distance: 15.0, exertion: 7, date: Date().addingTimeInterval(-86400)),
//        Activity(name: "Evening Swim", activityType: "Swimming", activityDescription: "A relaxing swim in the pool", duration: 60, distance: 1.0, exertion: 5, date: Date().addingTimeInterval(-172800)),
//        Activity(name: "Mountain Hike", activityType: "Hiking", activityDescription: "Climbing a steep mountain trail", duration: 120, distance: 8.0, exertion: 9, date: Date().addingTimeInterval(-259200)),
//        Activity(name: "Yoga Session", activityType: "Yoga", activityDescription: "A calming yoga session", duration: 45, distance: 0.0, exertion: 3, date: Date().addingTimeInterval(-345600)),
//        Activity(name: "Long Walk", activityType: "Walking", activityDescription: "A long walk in the park", duration: 90, distance: 6.5, exertion: 4, date: Date().addingTimeInterval(-432000)),
//        Activity(name: "Strength Training", activityType: "Strength", activityDescription: "Weight lifting at the gym", duration: 60, distance: 0.0, exertion: 8, date: Date().addingTimeInterval(-518400)),
//        Activity(name: "Cycling Tour", activityType: "Cycling", activityDescription: "A long cycling tour around the city", duration: 150, distance: 40.0, exertion: 8, date: Date().addingTimeInterval(-604800)),
//        Activity(name: "Jogging at the Beach", activityType: "Running", activityDescription: "Jogging along the beach at sunset", duration: 40, distance: 7.0, exertion: 6, date: Date().addingTimeInterval(-691200)),
//        Activity(name: "Rock Climbing", activityType: "Climbing", activityDescription: "Climbing rocks in the mountains", duration: 90, distance: 0.0, exertion: 10, date: Date().addingTimeInterval(-777600))
//    ]
    
    private var recentActivities: [Activity] {
            activities.sorted { $0.date > $1.date }.prefix(3).map { $0 }
        }
    
    var body: some View {
                NavigationStack {
                    VStack {
                        if recentActivities.isEmpty {
                            ContentUnavailableView(
                                "No Recent Activities",
                                systemImage: "figure.walk",
                                description: Text("Start your first adventure!")
                            )
                        } else {
                            List(recentActivities) { activity in
                                NavigationLink {
                                    ActivityDetailView(activity: activity)
                                } label: {
                                    ActivityNavigationLinkView(activity: activity)
                                }
                            }
                        }
                    }
                    .navigationTitle("Recent Activities")
                }
            }
        }

#Preview {
    ActivityOverviewView()
}
