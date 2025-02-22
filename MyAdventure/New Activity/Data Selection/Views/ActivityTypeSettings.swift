//
//  ActivitySettingsView.swift
//  AthleteWeather
//
//  Created by Tomáš Dušek on 02.11.2024.
//

import SwiftUI

struct ActivityTypeSettingsView: View {
    @State var activityType: ActivityType
    @Binding var selectedActivityType: ActivityType
    @Binding var isSelectionPresented: Bool
    
    var body: some View {
        
        
        VStack {
            HStack {
                Picker("Select activity", selection: $activityType) {
                    ForEach(ActivityType.allCases) { activity in
                        Text("\(activity.rawValue)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 200, height: 150)
                
            }
            .padding([.horizontal,. bottom])
 
            Button {
                selectedActivityType = activityType
                withAnimation(.smooth){
                    isSelectionPresented = false
                }
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
        .padding(.bottom)
    }
}


#Preview {
    @Previewable @State var activity: ActivityType = .cycling
    @Previewable @State var closeSelection: Bool = true
    ActivityTypeSettingsView(activityType: activity, selectedActivityType: $activity, isSelectionPresented: $closeSelection)
}
