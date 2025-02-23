//
//  NewActivityView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 22.01.2025.
//

import SwiftUI

struct NewActivityView: View {
    
    @Environment(\.modelContext)  var modelContext
    @Environment(\.dismiss)  var dismiss
    @StateObject private var vm = NewActivityViewModel()
    @State var name: String = ""
    @State var activityType: ActivityType = .running
    @State var activityDescription: String = ""
    @State var isDurationSelectionPresented = false
    @State var isDistanceSelectionPresented = false
    @State var isActivityTypeSelectionPresented = false
    @State var isExertionSelectionPresented = false
    @State var isDateSelectionPresented = false
    @State var selectedItemID: String? = nil // Track the selected item
    @State var distanceKm: Int = 0
    @State var distanceM: Int = 0
    @State var durationHr: Int = 0
    @State var durationMin: Int = 0
    @State var exertion: Int = 1
    @State var selectedDate = Date()
    @State var isPopupPresented = false
    @FocusState  var isTyping
    @State var isCancelAlertPresented = false
    @State var isEmptyNameAlertPresented = false
    var wasEmptyNameAlertPresented = false
    var editActivity: Activity?

    
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
                                    activityType: activityType,
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
                                    hours: durationHr,
                                    minutes: durationMin,
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
                                    kmDistance: distanceKm,
                                    mDistance: distanceM,
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
                                    exertion: exertion,
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
                            DateSelectionView(
                                date: selectedDate,
                                selectedDate: $selectedDate,
                                isSelectionPresented: $isDateSelectionPresented)
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
            .navigationTitle(editActivity?.name ?? "New Activity")
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
        .onAppear(){
            if let activity = editActivity {
                
                // Populate the state variables with the values from editActivity
                name = activity.name
                activityType = ActivityType(rawValue: activity.activityType) ?? .running
                activityDescription = activity.activityDescription
                
                // Calculate duration in hours and minutes
                durationHr = activity.duration / 60
                durationMin = activity.duration % 60
                
                // Calculate distance in kilometers and meters
                distanceKm = Int(activity.distance)
                distanceM = Int((activity.distance - Double(distanceKm)) * 10)
                
                exertion = activity.exertion
                selectedDate = activity.date
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
        let userProfileVM = UserProfileViewModel(modelContext: modelContext)
        let user = userProfileVM.userProfile
        
        if name.isEmpty {
            isEmptyNameAlertPresented = true
        } else {
            withAnimation {
                let duration = Int(durationHr) * 60 + Int(durationMin)
                let distance = Double(distanceKm) + Double(distanceM) / 10

                if let activity = editActivity {
                    // Update the existing activity
                    activity.name = name
                    activity.activityType = activityType.rawValue
                    activity.activityDescription = activityDescription
                    activity.duration = duration
                    activity.distance = distance
                    activity.exertion = exertion
                    activity.date = selectedDate
                    activity.caloriesBurned = vm.calculateCalories(activityDuration: duration, exertion: exertion, user: user)
                } else {
                    // Create a new activity
                    let newItem = Activity(
                        name: name,
                        activityType: activityType.rawValue,
                        activityDescription: activityDescription,
                        duration: duration,
                        distance: distance,
                        exertion: exertion,
                        date: selectedDate,
                        myActivity: true,
                        caloriesBurned: vm.calculateCalories(activityDuration: duration, exertion: exertion, user: user)
                    )
                    modelContext.insert(newItem)
                }

                // Save changes to the context
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save changes: \(error)")
                }

                dismiss() // Dismiss the view after saving
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

