//
//  DurationSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//
import Foundation
import SwiftUI

public struct DistanceSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedKmDistance: Int
    @Binding var selectedMDistance: Int
    
    public var body: some View {
        HStack {
            Spacer()
            Picker("Select km", selection: $selectedKmDistance) {
                ForEach(0...200, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            
            Text(",")
                .padding(.horizontal, -15)
            
            Picker("Select km", selection: $selectedMDistance) {
                ForEach(0...9, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 150)
            .padding(.leading, -25)
            
            Text("km")
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
    @Previewable @State var km: Int = 5
    @Previewable @State var m: Int = 5
    DistanceSelectionView(selectedKmDistance: $km, selectedMDistance: $m)
}
