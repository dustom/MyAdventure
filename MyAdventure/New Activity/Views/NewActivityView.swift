//
//  NewActivityView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI

struct NewActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var activityType: ActivityType = .running
    @State private var activityDescription: String = ""
    @State private var isDurationSelectionPresented = false
    @State private var isDistanceSelectionPresented = false
    @State private var isActivityTypeSelectionPresented = false
    @State private var isExertionSelectionPresented = false
    @State private var isDateSelectionPresented = false
    @State var distanceKm: Int = 0
    @State var distanceM: Int = 0
    @State var durationHr: Int = 0
    @State var durationMin: Int = 0
    @State var exertion: Int = 1
    @State var selectedDate = Date()
    
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                TextFieldFormView(textInput: $name, itemName: "Name")
                
                TextFieldFormView(textInput: $activityDescription, itemName: "Description")
                
                ClickableFormItemView(isSelectionPresented: $isActivityTypeSelectionPresented, itemName: "Activity", itemData: "\(activityType.rawValue)")
                
                ClickableFormItemView(isSelectionPresented: $isDurationSelectionPresented, itemName: "Duration", itemData: "\(durationHr) hr \(Int(durationMin)*10) min")
                
                ClickableFormItemView(isSelectionPresented: $isDistanceSelectionPresented, itemName: "Distance", itemData: "\(distanceKm),\(distanceM) km")
                
                ClickableFormItemView(isSelectionPresented: $isExertionSelectionPresented, itemName: "Percieved Exertion", itemData: "\(exertion)/10")
                
                ClickableFormItemView(isSelectionPresented: $isDateSelectionPresented, itemName: "Date", itemData: "\(selectedDate.formatted(date: .complete, time: .omitted))")
                
                
            }
            .padding()
            
            .sheet(isPresented: $isActivityTypeSelectionPresented) {
                ActivityTypeSettingsView( selectedActivityType: $activityType)
                    .presentationDetents([.fraction(0.5), .medium, .large])
            }
            
            
            .sheet(isPresented: $isDurationSelectionPresented) {
                DurationSelectionView(selectedHours: $durationHr, selectedMinutes: $durationMin)
                    .presentationDetents([.fraction(0.5), .medium, .large])
            }
            
            
            .sheet(isPresented: $isDistanceSelectionPresented) {
                DistanceSelectionView(selectedKmDistance: $distanceKm, selectedMDistance: $distanceM)
                    .presentationDetents([.fraction(0.5), .medium, .large])
            }
            
            .sheet(isPresented: $isExertionSelectionPresented) {
                ExertionSelectionView(selectedExertion: $exertion)
                    .presentationDetents([.fraction(0.3), .medium, .large])
            }
            
            .sheet(isPresented: $isDateSelectionPresented) {
                DateSelectionView(selectedDate: $selectedDate)
                    .presentationDetents([.fraction(0.8), .large])
            }
            
        }
        .navigationTitle("New Activity")
        .toolbarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    addItem()
                    
                }
            }
            
        }
        
    }
    
    private func addItem() {
        withAnimation {
            var duration: Int {
                return Int(durationHr) * 60 + Int(durationMin)
            }
            var distance: Double {
                return (Double(distanceKm)) + (Double(distanceM) / 10)
            }
            
            let newItem = Activity(name: name, activityType: activityType.rawValue, activityDescription: activityDescription, duration: duration, distance: distance, exertion: exertion)
            modelContext.insert(newItem)
            dismiss()
        }
    }
}

#Preview {
    NewActivityView()
}
