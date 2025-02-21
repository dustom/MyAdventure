//
//  ClickableFormItemView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 24.01.2025.
//

import SwiftUI

import SwiftUI

struct ClickableFormItemView<Content: View>: View {
    @Binding var isSelectionPresented: Bool
    var itemName: String
    var itemData: String
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            Button {
                withAnimation(.smooth) {
                    isSelectionPresented.toggle()
                }
            } label: {
                
                HStack {
                    HStack() {
                        HStack {
                            Text(itemName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        HStack {
                            Text(itemData)
                                .padding(.horizontal)
                        }
                    
                    }
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isSelectionPresented ? 90 : 0))
                        .animation(.smooth, value: isSelectionPresented)
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isSelectionPresented {
                content()
            }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    @Previewable @State var showSheet = false
    @Previewable @State var closeSelection: Bool = true
    ClickableFormItemView(isSelectionPresented: $showSheet, itemName: "Item name", itemData: "Item data") {
        ExertionSelectionView(selectedExertion: .constant(1), isSelectionPresented: $closeSelection)
    }
}
