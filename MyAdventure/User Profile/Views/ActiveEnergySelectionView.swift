//
//  ActiveEnergySelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 21.02.2025.
//

import SwiftUI

struct ActiveEnergySelectionView: View {
    @State private var kcal: Int = 0
    @Binding var selectedKcal: Int
    @Binding var isSelectionPresented: Bool
        
        
        public var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Picker("Select kcal", selection: $kcal) {
                        ForEach(0...1000, id: \.self) { number in
                            Text("\(number*10)")
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
        @Previewable @State var kcal: Int = 30
        @Previewable @State var closeSelection: Bool = true
        ActiveEnergySelectionView(selectedKcal: $kcal, isSelectionPresented: $closeSelection)
}
