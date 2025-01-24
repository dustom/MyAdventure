//
//  TextFieldFormView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 24.01.2025.
//

import SwiftUI

struct TextFieldFormView: View {
   @Binding var textInput: String
    var itemName: String
    
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
                    TextField("Fill in the \(itemName.lowercased()).", text: $textInput)
                }
                .padding(.leading, 10)
                Spacer()
                
            }
            VStack{
                Button("Cancel", systemImage: "xmark.circle.fill") {
                    textInput = ""
                }
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundStyle(.secondary.opacity(0.7))
            }
            .padding()
        }
        .padding(.leading, 10)
        .padding(.bottom, 5)
        .frame(height: 70)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
}

#Preview {
    @Previewable @State var activityDescription: String = "My description"
    TextFieldFormView(textInput: $activityDescription, itemName: "Name")
}
