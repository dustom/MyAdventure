//
//  DateSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 24.01.2025.
//

import SwiftUI

struct DateSelectionView: View {
    @State var date: Date
    @Binding var selectedDate: Date
    @Binding var isSelectionPresented: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                DatePicker("Select activity date", selection: $date, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            .padding([.horizontal,. bottom])
            
            Button {
                selectedDate = date
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
            Spacer()
        }
        .padding(.bottom)
    }
}

#Preview {
    @Previewable @State var date: Date = Date()
    @Previewable @State var closeSelection: Bool = true
    DateSelectionView(date: date, selectedDate: $date, isSelectionPresented: $closeSelection)
}
