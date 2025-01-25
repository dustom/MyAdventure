//
//  DurationSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//
import Foundation
import SwiftUI

public struct DurationSelectionView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int
    @Binding var isSelectionPresented: Bool
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker("Select hours", selection: $hours) {
                    ForEach(0...200, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 150)
                Text("hr")
                
                Picker("Select minutes", selection: $minutes) {
                    ForEach(0...5, id: \.self) { number in
                        Text("\(number*10)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 150)
                Text("min")
                Spacer()
            }
            .padding([.horizontal,. bottom])
            
            Button {
                selectedHours = hours
                selectedMinutes = minutes
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
            Spacer ()
        }
        .padding(.bottom)
    }
    
}

#Preview {
    @Previewable @State var hr: Int = 5
    @Previewable @State var min: Int = 30
    @Previewable @State var closeSelection: Bool = true
    DurationSelectionView(selectedHours: $hr, selectedMinutes: $min, isSelectionPresented: $closeSelection)
}
