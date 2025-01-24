//
//  DurationSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//
import Foundation
import SwiftUI

public struct ExertionSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var exertion: Int = 1
    @Binding var selectedExertion: Int
    
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
            
            Spacer ()
            
            HStack {
                Picker("Select km", selection: $exertion) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.palette)
                .padding()
            }
            Spacer()
            
            Button {
                selectedExertion = exertion
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
    @Previewable @State var exertion: Int = 5
    ExertionSelectionView(selectedExertion: $exertion)
}
