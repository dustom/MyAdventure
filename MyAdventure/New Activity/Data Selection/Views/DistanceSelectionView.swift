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
    @State private var kmDistance: Int = 0
    @State private var mDistance: Int = 0
    @Binding var selectedKmDistance: Int
    @Binding var selectedMDistance: Int
    
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
                Picker("Select km", selection: $kmDistance) {
                    ForEach(0...200, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 150)
                
                Text(",")
                    .padding(.horizontal, -15)
                
                Picker("Select fraction of a km", selection: $mDistance) {
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
            Spacer()
            
            Button {
                selectedKmDistance = kmDistance
                selectedMDistance = mDistance
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
    @Previewable @State var km: Int = 5
    @Previewable @State var m: Int = 5
    DistanceSelectionView(selectedKmDistance: $km, selectedMDistance: $m)
}
