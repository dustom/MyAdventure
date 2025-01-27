//
//  ContentView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI
import SwiftData

struct ActivitiesView: View {
    @Environment(\.modelContext) private var modelContext
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

    
    @State private var isNewActivityPresented = false
    @State var searchText: String = ""
    @State var filteringOptions: FilterOptions = .all
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredActivities) { item in
                    NavigationLink {
                        Text("\(item.name)")
                    } label: {
                        Text("\(item.name)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .overlay{
                if activities.isEmpty {
                    ContentUnavailableView("No Activities", systemImage: "square.3.layers.3d.slash", description: Text("Create an activity by tapping the plus button."))
                } else if filteredActivities.isEmpty && !searchText.isEmpty{
                    ContentUnavailableView.search(text: searchText)
                }
            }
        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Select an Option", selection: $filteringOptions) {
                            ForEach(FilterOptions.allCases) { filter in
                                HStack {
                                    Text("\(filter.label)")
                                    Image(systemName: "\(filter.arrow)")
                                }
                            }
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Label("Sort", systemImage: "line.3.horizontal.decrease")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button("New Activity", systemImage: "plus") {
                        isNewActivityPresented =  true
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("My Activities")
        }
        
        .fullScreenCover(isPresented: $isNewActivityPresented) {
            NewActivityView()
        }
        
        
    }
    
    var sortedActivities: [Activity] {
        switch filteringOptions {
        case .all:
            return activities
        case .distanceAscending:
            return activities.sorted { $0.distance < $1.distance }
        case .distanceDescending:
            return activities.sorted { $0.distance > $1.distance }
            case .dateAscending:
            return activities.sorted { $0.date < $1.date }
        case .dateDescending:
            return activities.sorted { $0.date > $1.date }
            case .durationAscending:
            return activities.sorted { $0.duration < $1.duration }
        case .durationDescending:
            return activities.sorted { $0.duration > $1.duration}
        }
        
    }
    
    var filteredActivities: [Activity] {
        guard !searchText.isEmpty else { return sortedActivities }
        return sortedActivities.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(activities[index])
            }
        }
    }
    
}



#Preview {
    ActivitiesView()
        .modelContainer(for: Activity.self, inMemory: true)
}
