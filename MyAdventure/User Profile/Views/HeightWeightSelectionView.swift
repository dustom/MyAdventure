//
//  HeightWeightSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 21.02.2025.
//

import SwiftUI

struct HeightWeightSelectionView: View {
    @State private var value: Int = 0
    @Binding var selectedValue: Int
    @Binding var isSelectionPresented: Bool
    var isHeight = false
        
        
        public var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Picker("Select value", selection: $value) {
                        ForEach(0...500, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: 150)
                    Text(isHeight ? "cm" : "kg")
                    Spacer()
                }
                .padding([.horizontal,. bottom])
                
                Button {
                    selectedValue = value
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
        @Previewable @State var value: Int = 30
        @Previewable @State var closeSelection: Bool = true
        HeightWeightSelectionView(selectedValue: $value, isSelectionPresented: $closeSelection)
}
