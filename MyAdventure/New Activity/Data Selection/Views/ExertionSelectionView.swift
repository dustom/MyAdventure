//
//  DurationSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 23.01.2025.
//
import Foundation
import SwiftUI

public struct ExertionSelectionView: View {
    @State var exertion: Int
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
    ExertionSelectionView(exertion: exertion, selectedExertion: $exertion, isSelectionPresented: $closeSelection)
}
