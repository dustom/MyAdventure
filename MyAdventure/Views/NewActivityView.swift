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
    @State private var name: String = "Name"
    @State private var activityType: ActivityType = .running
    @State private var activityDescription: String = ""
    @State private var isDurationSelectionPresented = false
    @State private var isDistanceSelectionPresented = false
    @State var distanceKm: Int = 0
    @State var distanceM: Int = 0
    @State var durationHr: Int = 0
    @State var durationMin: Int = 0
    
    
    
    var body: some View {
        
        
        
        List {
            NavigationLink {
                Text("Activity name")
                // put settings here
            } label: {
                
                HStack{
                    Text("\(name)")
                    Spacer()
                }
            }
            NavigationLink {
                Text("Activity description")
                // put settings here
            } label: {
                
                HStack{
                    Text("Description")
                    Spacer()
                }
            }
            NavigationLink {
                Text("Activity type")
            } label: {
                
                HStack{
                    Text("\(activityType.rawValue)")
                    Spacer()
                }
            }
            HStack{
                Button("Duration"){
                    isDurationSelectionPresented = true
                }
                Spacer()
                Text("\(durationHr) hr \(Int(durationMin)*10) min")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.5))
                    .bold()
             
            }
            .foregroundStyle(.primary)
            HStack{
                Button("Distance"){
                    isDistanceSelectionPresented = true
                }
                Spacer()
                Text("\(distanceKm),\(distanceM) km")
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.5))
                    .bold()
             
            }
            .foregroundStyle(.primary)
            
            
            
            .sheet(isPresented: $isDurationSelectionPresented) {
                DurationSelectionView(selectedHours: $durationHr, selectedMinutes: $durationMin)
                    .presentationDetents([.fraction(0.30), .medium, .large])
            }
            
            .sheet(isPresented: $isDistanceSelectionPresented) {
                DistanceSelectionView(selectedKmDistance: $distanceKm, selectedMDistance: $distanceM)
                    .presentationDetents([.fraction(0.30), .medium, .large])
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
            
            let newItem = Activity(name: name, activityType: activityType.rawValue, activityDescription: activityDescription, duration: duration, distance: distance)
            modelContext.insert(newItem)
            dismiss()
        }
    }
}

#Preview {
    NewActivityView()
}
