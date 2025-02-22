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
                Picker("Select steps", selection: $steps) {
                    ForEach(0...100, id: \.self) { number in
                        Text("\(number*500)")
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
