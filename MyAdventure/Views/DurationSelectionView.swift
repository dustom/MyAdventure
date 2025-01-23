//
//  DurationSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//
import Foundation
import SwiftUI

public struct DurationSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int
    
    public var body: some View {
        HStack {
            Spacer()
            Picker("Select hours", selection: $selectedHours) {
                ForEach(0...200, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            Text("hr")
            
            Picker("Select minutes", selection: $selectedMinutes) {
                ForEach(0...5, id: \.self) { number in
                    Text("\(number*10)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            Text("min")
            Spacer()
        }
        
        Button {
                    dismiss()
                } label: {
                    Text("Confirm")
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: 100, maxHeight: 45)
                        .background(.secondary)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) // Ensures no additional button styling
                }
    
}

#Preview {
    @Previewable @State var hr: Int = 5
    @Previewable @State var min: Int = 30
    DurationSelectionView(selectedHours: $hr, selectedMinutes: $min)
}
