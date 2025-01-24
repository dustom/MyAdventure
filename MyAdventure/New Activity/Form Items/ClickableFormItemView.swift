//
//  ClickableFormItemView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 24.01.2025.
//

import SwiftUI

struct ClickableFormItemView: View {
    @Binding var isSelectionPresented: Bool
    var itemName: String
    var itemData: String
    
    var body: some View {
        HStack {
            VStack {
                HStack{
                    Text ("\(itemName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding([.top, .leading], 10)
                HStack{
                    Text("\(itemData)")
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 1)
                Spacer()
                
            }
            VStack {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .padding(.leading, 10)
        
        .frame(height: 70)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            isSelectionPresented = true
        }
    }
}

#Preview {
    @Previewable @State var showSheet = false
    ClickableFormItemView(isSelectionPresented: $showSheet, itemName: "Item name", itemData: "Item data")
}
