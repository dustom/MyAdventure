//
//  NewActivityView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI

struct NewActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var activityType: ActivityType = .running
    @State private var activityDescription: String = ""
    @State private var isDurationSelectionPresented = false
    @State private var isDistanceSelectionPresented = false
    @State private var isActivityTypeSelectionPresented = false
    @State private var isExertionSelectionPresented = false
    @State private var isDateSelectionPresented = false
    @State private var selectedItemID: String? = nil // Track the selected item
    @State var distanceKm: Int = 0
    @State var distanceM: Int = 0
    @State var durationHr: Int = 0
    @State var durationMin: Int = 0
    @State var exertion: Int = 1
    @State var selectedDate = Date()
    @State private var isPopupPresented = false
    @FocusState private var isTyping
    @State private var isCancelAlertPresented = false
    @State private var isEmptyNameAlertPresented = false
    private var wasEmptyNameAlertPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ZStack {
                        VStack {
                            TextFieldFormView(textInput: $name, itemName: "Name")
                                .focused($isTyping)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(isEmptyNameAlertPresented ? Color.red.opacity(0.7) : .primary.opacity(0.0))
                                )
                                .alert(isPresented: $isEmptyNameAlertPresented) {
                                    Alert(
                                        title: Text("Missing name"),
                                        message: Text("You need to fill in the activity name before saving it.")
                                    )
                                }
                            
                            TextFieldFormView(textInput: $activityDescription, itemName: "Description")
                                .focused($isTyping)
                            
                            ClickableFormItemView(
                                isSelectionPresented: $isActivityTypeSelectionPresented,
                                itemName: "Activity",
                                itemData: "\(activityType.rawValue)"
                            ) {
                                ActivityTypeSettingsView(
                                    selectedActivityType: $activityType,
                                    isSelectionPresented: $isActivityTypeSelectionPresented
                                )
                                .onAppear(){
                                    withAnimation(.smooth){
                                        isTyping = false
                                        resetOtherSelections(except: "Activity")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Activity", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Activity")
                            
                            ClickableFormItemView(
                                isSelectionPresented: $isDurationSelectionPresented,
                                itemName: "Duration",
                                itemData: "\(durationHr) hr \(Int(durationMin) * 10) min"
                            ) {
                                DurationSelectionView(
                                    selectedHours: $durationHr,
                                    selectedMinutes: $durationMin,
                                    isSelectionPresented: $isDurationSelectionPresented
                                )
                                .onAppear(){
                                    withAnimation(.smooth){
                                        isTyping = false
                                        resetOtherSelections(except: "Duration")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Duration", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Duration")
                            
                            ClickableFormItemView(
                                isSelectionPresented: $isDistanceSelectionPresented,
                                itemName: "Distance",
                                itemData: "\(distanceKm),\(distanceM) km"
                            ) {
                                DistanceSelectionView(
                                    selectedKmDistance: $distanceKm,
                                    selectedMDistance: $distanceM,
                                    isSelectionPresented: $isDistanceSelectionPresented
                                )
                                .onAppear(){
                                    withAnimation(.smooth){
                                        isTyping = false
                                        resetOtherSelections(except: "Distance")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Distance", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Distance")
                            
                            
                            ClickableFormItemView(
                                isSelectionPresented: $isExertionSelectionPresented,
                                itemName: "Percieved Exertion",
                                itemData: "\(exertion)/10"
                            ) {
                                ExertionSelectionView(
                                    selectedExertion: $exertion,
                                    isSelectionPresented:$isExertionSelectionPresented)
                                .onAppear(){
                                    withAnimation(.smooth){
                                        isTyping = false
                                        resetOtherSelections(except: "Exertion")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Exertion", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Exertion")
                        }
                    }.onTapGesture {
                        isTyping = false
                    }
                    VStack{
                        ClickableFormItemView(
                            isSelectionPresented: $isDateSelectionPresented,
                            itemName: "Date",
                            itemData: "\(selectedDate.formatted(date: .numeric, time: .omitted))"
                        ) {
                            DateSelectionView(selectedDate: $selectedDate, isSelectionPresented: $isDateSelectionPresented)
                                .onAppear(){
                                    withAnimation(.smooth){
                                        resetOtherSelections(except: "Date")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Date", proxy: proxy)
                                        }
                                    }
                                }
                        }
                        .padding(.bottom)
                        .id("Date") // Assign unique ID
                        
                    }
                }
                
                .padding(.horizontal)
                
            }
            .navigationTitle("New Activity")
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addItem()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isCancelAlertPresented = true
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button("Cancel") {
                            isTyping = false
                        }
                        Spacer()
                        Button("Done", systemImage: "keyboard.chevron.compact.down"){
                            isTyping = false
                        }
                    }
                }
            }
        }
        
        .alert(isPresented: $isCancelAlertPresented) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want leave without saving your activity?"),
                primaryButton: .destructive(Text("Yes")) {
                    dismiss()
                },
                secondaryButton: .cancel(Text("No")) {
                    
                }
            )
        }
        
        
    }
    
    private func scrollToItem(_ id: String, proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(id, anchor: .top)
        }
    }
    
    private func addItem() {
        if name == "" {
            isEmptyNameAlertPresented = true
        } else {
            withAnimation {
                let duration = Int(durationHr) * 60 + Int(durationMin)
                let distance = Double(distanceKm) + Double(distanceM) / 10
                let newItem = Activity(
                    name: name,
                    activityType: activityType.rawValue,
                    activityDescription: activityDescription,
                    duration: duration,
                    distance: distance,
                    exertion: exertion,
                    date: selectedDate
                )
                modelContext.insert(newItem)
                dismiss()
            }
        }
    }
    
    // Helper function to reset all selection states except the one being toggled
    private func resetOtherSelections(except selected: String) {
        switch selected {
        case "Duration":
            isDistanceSelectionPresented = false
            isActivityTypeSelectionPresented = false
            isExertionSelectionPresented = false
            isDateSelectionPresented = false
        case "Distance":
            isDurationSelectionPresented = false
            isActivityTypeSelectionPresented = false
            isExertionSelectionPresented = false
            isDateSelectionPresented = false
        case "Activity":
            isDurationSelectionPresented = false
            isDistanceSelectionPresented = false
            isExertionSelectionPresented = false
            isDateSelectionPresented = false
        case "Exertion":
            isDurationSelectionPresented = false
            isDistanceSelectionPresented = false
            isActivityTypeSelectionPresented = false
            isDateSelectionPresented = false
        case "Date":
            isDurationSelectionPresented = false
            isDistanceSelectionPresented = false
            isActivityTypeSelectionPresented = false
            isExertionSelectionPresented = false
        default:
            break
        }
    }
}

#Preview {
    NewActivityView()
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

