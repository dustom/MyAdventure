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
    @Binding var isSelectionPresented: Bool
    
    public var body: some View {
        
            VStack {

                HStack {
                    Picker("Select km", selection: $exertion) {
                        ForEach(1...10, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.palette)
                    .padding([.horizontal,. bottom])
                }
                Spacer()
                
                Button {
                    selectedExertion = exertion
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
    @Previewable @State var exertion: Int = 5
    @Previewable @State var closeSelection: Bool = true
    ExertionSelectionView(selectedExertion: $exertion, isSelectionPresented: $closeSelection)
}
