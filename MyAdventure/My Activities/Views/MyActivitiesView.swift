//
//  ContentView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI
import SwiftData
import HealthKit

struct MyActivitiesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var healthManager: HealthManager
    @StateObject private var vm = ActivityViewModel()
    @Query private var myActivities: [Activity]
    @State private var hkActivities: [Activity] = []
    @State private var activities: [Activity] = []
    @State private var isNewActivityPresented = false
    @State private var searchText: String = ""
    @State private var filteringOptions: FilterOptions = .dateDescending
    @State private var isFilterOptionsPresented = false
    @State private var selectedActivities: Set<ActivityType> = Set(ActivityType.allCases)
    
    

    var body: some View {
        NavigationStack {
            Group {
                switch vm.state {
                case .error:
                    Text("Error loading activities, pull down to refresh.")
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    List {
                        ForEach(searchedActivities) { item in
                            NavigationLink {
                                ActivityDetailView(activity: item)
                            } label: {
                                ActivityNavigationLinkView(activity: item)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    .searchable(text: $searchText)
                    .autocorrectionDisabled()
                    .overlay {
                        if activities.isEmpty {
                            ContentUnavailableView("No Activities", systemImage: "square.3.layers.3d.slash", description: Text("Create an activity by tapping the plus button."))
                        } else if searchedActivities.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView.search(text: searchText)
                        } else if filteredActivities.isEmpty {
                            ContentUnavailableView("No Activities Found", systemImage: "square.3.layers.3d.slash", description: Text(selectedActivities == [] ? "Select at least one activity type filter." : "Try a different filter or create a new activity of the following type: \(selectedActivities.map(\.rawValue).joined(separator: ", "))."))
                        }
                    }
                    .refreshable{
                        loadActivities()
                    }
                }
            }
            .navigationTitle("My Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sort and Filter", systemImage: "line.3.horizontal.decrease") {
                        isFilterOptionsPresented = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New Activity", systemImage: "plus") {
                        isNewActivityPresented = true
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: myActivities) {
            loadActivities()
        }
        .onAppear {
            loadActivities()
        }
        .fullScreenCover(isPresented: $isNewActivityPresented) {
            NewActivityView()
        }
        .sheet(isPresented: $isFilterOptionsPresented) {
            FilterOptionsView(filteringOptions: $filteringOptions, selectedActivities: $selectedActivities)
        }
    }

    
    
    var sortedActivities: [Activity] {
        switch filteringOptions {
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
        sortedActivities.filter {activity in
            selectedActivities.contains { $0.rawValue == activity.activityType }
        }
    }
    
    var searchedActivities: [Activity] {
        guard !searchText.isEmpty else { return filteredActivities }
        // Filter the already type-filtered activities
        return filteredActivities.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                for index in offsets {
                    modelContext.delete(activities[index])
                }
            }
        }

    
    private func loadActivities() {
        Task {
            await vm.loadActivities()
            activities = vm.allActivites + myActivities
        }
        
    }
    
}

#Preview {
    MyActivitiesView()
        .modelContainer(for: Activity.self, inMemory: true)
}
