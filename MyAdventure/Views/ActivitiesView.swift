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
    @State private var isNewActivityPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { item in
                    NavigationLink {
                        Text("\(item.name)")
                    } label: {
                        Text("\(item.name)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sort", systemImage: "line.3.horizontal.decrease") {
                        
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink(destination: NewActivityView()) {
                        Label("New Activity", systemImage: "plus")
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("My Activities")
        }
        
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
