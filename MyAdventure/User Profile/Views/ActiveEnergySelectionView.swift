//
//  ActiveEnergySelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 21.02.2025.
//

import SwiftUI

struct ActiveEnergySelectionView: View {
    @State var kcal: Int
    @Binding var selectedKcal: Int
    @Binding var isSelectionPresented: Bool
        
        
        public var body: some View {
            VStack {
                HStack {
                    Spacer()
                    let kcalSize = 10
                    let range = stride(from: 0, through: 10_000, by: kcalSize)

                    Picker("Select steps", selection: $kcal) {
                        ForEach(Array(range), id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: 150)
                    Text("kcal")
                    Spacer()
                }
                .padding([.horizontal,. bottom])
                
                Button {
                    selectedKcal = kcal
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
        @Previewable @State var kcal: Int = 300
        @Previewable @State var closeSelection: Bool = true
        ActiveEnergySelectionView(kcal: kcal, selectedKcal: $kcal, isSelectionPresented: $closeSelection)
}
