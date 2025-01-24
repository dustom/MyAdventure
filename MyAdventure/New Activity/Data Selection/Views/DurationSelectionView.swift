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
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int
    
    public var body: some View {
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
            Spacer ()
            
            Button {
                selectedHours = hours
                selectedMinutes = minutes
                dismiss()
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
    }
    
}

#Preview {
    @Previewable @State var hr: Int = 5
    @Previewable @State var min: Int = 30
    DurationSelectionView(selectedHours: $hr, selectedMinutes: $min)
}
