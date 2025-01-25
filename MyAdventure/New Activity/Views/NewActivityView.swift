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
    
    
    // TODO: maku sure that user is asked, if they really want to leave - ie. when swiping left 
    
    var body: some View {
        
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {
                    VStack {
                        TextFieldFormView(textInput: $name, itemName: "Name")
                            .focused($isTyping)
                        
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollToItem("Activity", proxy: proxy)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollToItem("Duration", proxy: proxy)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollToItem("Distance", proxy: proxy)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollToItem("Exertion", proxy: proxy)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollToItem("Date", proxy: proxy)
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
        }
        
        
    }
    
    private func scrollToItem(_ id: String, proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(id, anchor: .top)
        }
    }
    
    private func addItem() {
        withAnimation {
            let duration = Int(durationHr) * 60 + Int(durationMin)
            let distance = Double(distanceKm) + Double(distanceM) / 10
            let newItem = Activity(
                name: name,
                activityType: activityType.rawValue,
                activityDescription: activityDescription,
                duration: duration,
                distance: distance,
                exertion: exertion
            )
            modelContext.insert(newItem)
            dismiss()
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

