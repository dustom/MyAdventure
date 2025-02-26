//
//  FilterOptionsView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 28.01.2025.
//

import SwiftUI

import SwiftUI

struct FilterOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var filteringOptions: FilterOptions
    @Binding var selectedActivities: Set<ActivityType>
    private var selectAllActivities: Bool {
        selectedActivities == Set(ActivityType.allCases)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Sort by:") {
                    ForEach(FilterOptions.allCases) { filter in
                        HStack {
                            Image(systemName: "\(filter.arrow)")
                            Text("\(filter.label)")
                            Spacer()
                            if self.filteringOptions == filter {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.filteringOptions = filter
                        }
                    }
                }
                Section("Displayed Activities:") {
                    HStack {
                        Text("All")
                        Spacer()
                        Image(systemName: selectAllActivities ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectAllActivities ? .blue : .gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectAllActivities {
                            selectedActivities = []
                        } else {
                            selectedActivities = Set(ActivityType.allCases)
                        }
                    }
                    
                    ForEach(ActivityType.allCases) { activity in
                        HStack {
                            Text("\(activity.rawValue)")
                            Spacer()
                            Image(systemName: selectedActivities.contains(activity) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedActivities.contains(activity) ? .blue : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedActivities.contains(activity) {
                                selectedActivities.remove(activity)
                            } else {
                                selectedActivities.insert(activity)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Sorting and Filtering")
        }
    }
}

#Preview {
    @Previewable @State var filteringOptions: FilterOptions = .allCases.first!
    @Previewable @State var selectedActivities: Set<ActivityType> = Set(ActivityType.allCases)
    FilterOptionsView(filteringOptions: $filteringOptions, selectedActivities: $selectedActivities)
}
