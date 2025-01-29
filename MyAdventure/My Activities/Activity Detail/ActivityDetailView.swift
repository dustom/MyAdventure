//
//  ActivityDetail.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    var vm = ActivityViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
               
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(activity.name)
                                .font(.title2.bold())
                            
                            Image(systemName: vm.getActivityIcon(for: activity.activityType))
                                .font(.title3)
                                .foregroundColor(.blue)
                            Spacer()
                            Text(activity.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack{
                            Text(activity.activityType.capitalized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                    }
                
                // Metrics Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    MetricCell(value: vm.formatDuration(activity.duration), label: "Duration")
                    MetricCell(value: String(format: "%.1f km", activity.distance), label: "Distance")
                    MetricCell(value: "\(activity.exertion)/10", label: "Exertion")
                    if vm.calculateRate(activity: activity) != "" {
                        MetricCell(value: vm.calculateRate(activity: activity), label: "Speed")
                    }
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    
                    Text(activity.activityDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.thickMaterial)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct MetricCell: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thickMaterial)
        .cornerRadius(12)
    }
}

// Preview
#Preview {
    ActivityDetailView( activity: Activity(name: "Cycling Tour", activityType: "Cycling", activityDescription: "A long cycling tour around the city", duration: 150, distance: 40.0, exertion: 8, date: Date().addingTimeInterval(-604800)))
}
