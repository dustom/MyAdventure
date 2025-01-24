//
//  DateSelectionView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 24.01.2025.
//

import SwiftUI

struct DateSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    @Binding var selectedDate: Date
   
    
    var body: some View {
        
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
                DatePicker("Select activity date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            .padding()
            Spacer()
            
            Button {
                selectedDate = date
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
    @Previewable @State var date: Date = Date()
    DateSelectionView(selectedDate: $date)
}
