//
//  StepsSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 21.02.2025.
//

import SwiftUI

struct StepsSelectionView: View {
    @State var steps: Int
    @Binding var selectedSteps: Int
    @Binding var isSelectionPresented: Bool
    
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                let stepSize = 500
                let range = stride(from: 0, through: 100_000, by: stepSize) // 0 to 100,000 in steps of 2,000

                Picker("Select steps", selection: $steps) {
                    ForEach(Array(range), id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 120, height: 150)
                Text("steps")
                Spacer()
            }
            .padding([.horizontal,. bottom])
            
            Button {
                selectedSteps = steps
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
    @Previewable @State var steps: Int = 30
    @Previewable @State var closeSelection: Bool = true
    StepsSelectionView(steps: steps, selectedSteps: $steps, isSelectionPresented: $closeSelection)
}
