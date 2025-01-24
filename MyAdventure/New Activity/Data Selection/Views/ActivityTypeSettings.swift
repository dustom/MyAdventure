//
//  ActivitySettingsView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 02.11.2024.
//

import SwiftUI

struct ActivityTypeSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var activityType: ActivityType = .running
    @Binding var selectedActivityType: ActivityType
    
    
    var body: some View {
        
        
        VStack {
            HStack
            {
                Spacer ()
                Button("Cancel", systemImage: "xmark.circle.fill") {
                    dismiss()
                }
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundStyle(.secondary.opacity(0.7))
                .padding(.trailing)
                .padding(.top, 20)
            }

            HStack {
                Picker("Select activity", selection: $activityType) {
                    ForEach(ActivityType.allCases) { activity in
                        Text("\(activity.rawValue)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 200, height: 150)
                
            }
            
            Spacer()
            
            Button {
                selectedActivityType = activityType
                dismiss()
            } label: {
                Text("Confirm")
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: 100, maxHeight: 45)
                    .background(.thinMaterial)
                    .cornerRadius(8)
            }
            Spacer()
        }
    }
}


#Preview {
    @Previewable @State var activity: ActivityType = .cycling
    ActivityTypeSettingsView(selectedActivityType: $activity)
}
