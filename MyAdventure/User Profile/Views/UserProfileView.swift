//
//  UserProfileView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UserProfileView: View {
    @Environment(\.modelContext)  var modelContext
    @State var isHeightEditPresented = false
    @State var isWeightEditPresented = false
    @State var isBirthdateEditPresented = false
    @State var isActiveTimeEditPresented = false
    @State var isEnergyBurnedEditPresented = false
    @State var isStepsEditPresented = false
    @State var isInEditMode = false
    
    
    @State private var userImage: UIImage = UIImage(resource: .heinrich)
    @State private var userPickedImage: PhotosPickerItem?
    @State private var userImageData: Data?
    @State var userName: String = ""
    @State var birthdate: Date = Date()
    @State var activeMinutes = 2
    @State var activeHours = 1
    @State var activeEnergy = 500
    @State var steps = 10000
    @State var height = 175
    @State var weight = 65
    
    var body: some View {
        NavigationStack{
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        
                        PhotosPicker(selection: $userPickedImage, matching: .images) {
                            ZStack {
                                Image(uiImage: userImage)
                                    .resizable()
                                    .scaledToFill()
                                
                                if isInEditMode {
                                    VStack{
                                        Text("Edit")
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.thinMaterial.opacity(0.7))
                                }
                            }
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        }
                        .disabled(!isInEditMode)
                        
                        
                        // when the user picks a different photo it is transfered to Data so it can be stored in SwiftData
                        .onChange(of: userPickedImage) { _, _ in
                            Task {
                                if let userPickedImage,
                                   let data = try? await userPickedImage.loadTransferable(type: Data.self) {
                                    self.userImageData = data
                                    if let image = UIImage(data: data) {
                                        userImage = image
                                    }
                                }
                                userPickedImage = nil
                            }
                        }
                        
                        
                        HStack {
                            HStack{
                                TextField("Fill in the user name", text: $userName)
                            }
                            .disabled(!isInEditMode)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding()
                            
                            
                            if isInEditMode {
                                VStack{
                                    Button("Cancel", systemImage: "xmark.circle.fill") {
                                        userName = ""
                                    }
                                    .labelStyle(.iconOnly)
                                    .font(.title2)
                                    .foregroundStyle(.secondary.opacity(0.7))
                                }
                                .padding()
                            }
                        }
                        .background(.thinMaterial.opacity(isInEditMode ? 1 : 0))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                    }
                    
                    VStack {
                        HStack {
                            Text("Info")
                            Spacer()
                        }
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isHeightEditPresented,
                            itemName: "Height",
                            itemData: "\(height) cm",
                            isInEditMode: isInEditMode) {
                                HeightWeightSelectionView(
                                    value: height,
                                    selectedValue: $height,
                                    isSelectionPresented: $isHeightEditPresented,
                                    isHeight: true)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Height")
                                        // the DispatchQueue makes sure, that the animation is completed and then it scrolls to the given item
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Height", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Height")
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isWeightEditPresented,
                            itemName: "Weight",
                            itemData: "\(weight) kg",
                            isInEditMode: isInEditMode) {
                                HeightWeightSelectionView(
                                    value: weight,
                                    selectedValue: $weight,
                                    isSelectionPresented: $isWeightEditPresented)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Weight")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Weight", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Weight")
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isBirthdateEditPresented,
                            itemName: "Date of Birth",
                            itemData: "\(birthdate.formatted(date: .numeric, time: .omitted))",
                            isInEditMode: isInEditMode) {
                                DateSelectionView(
                                    date: birthdate,
                                    selectedDate: $birthdate,
                                    isSelectionPresented: $isBirthdateEditPresented)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Date of Birth")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Date of Birth", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Date of Birth")
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("Goals")
                            Spacer()
                        }
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isStepsEditPresented,
                            itemName: "Steps",
                            itemData: String(steps).formattedWithSpaces(),
                            isInEditMode: isInEditMode) {
                                StepsSelectionView(
                                    steps: steps,
                                    selectedSteps: $steps,
                                    isSelectionPresented: $isStepsEditPresented)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Steps")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Steps", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Steps")
                        
                        let activeTime = (activeHours * 60) + activeMinutes*10
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isActiveTimeEditPresented,
                            itemName: "Active Time",
                            itemData: "\(activeTime) min",
                            isInEditMode: isInEditMode) {
                                DurationSelectionView(
                                    hours: activeHours,
                                    minutes: activeMinutes,
                                    selectedHours: $activeHours,
                                    selectedMinutes: $activeMinutes,
                                    isSelectionPresented: $isActiveTimeEditPresented)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Active Time")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Active Time", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Active Time")
                        
                        ClickableFormItemView(
                            isSelectionPresented: $isEnergyBurnedEditPresented,
                            itemName: "Energy Burned",
                            itemData: String(activeEnergy).formattedWithSpaces() + " kcal",
                            isInEditMode: isInEditMode) {
                                ActiveEnergySelectionView(
                                    kcal: activeEnergy,
                                    selectedKcal: $activeEnergy,
                                    isSelectionPresented: $isEnergyBurnedEditPresented)
                                .onAppear {
                                    withAnimation(.smooth) {
                                        resetOtherSelections(except: "Energy Burned")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            scrollToItem("Energy Burned", proxy: proxy)
                                        }
                                    }
                                }
                            }
                            .id("Energy Burned")
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isInEditMode ? "Done" : "Edit"){
                        
                        //this is not defined in the initialization part to make sure that he modelContext is passed from the environment
                        let vm = UserProfileViewModel(modelContext: modelContext)
                        withAnimation {
                            isInEditMode.toggle()
                            
                            // this makes sure that all form items are closed after saving the user profile
                            if !isInEditMode {
                                closeEdit()
                            }
                            // the userProfile is always saved after finishing editing
                            vm.saveUserProfile(
                                activeHours: activeHours,
                                activeMinutes: activeMinutes,
                                userName: userName,
                                height: height,
                                weight: weight,
                                birthdate: birthdate,
                                steps: steps,
                                activeEnergy: activeEnergy,
                                userImageData: userImageData)
                        }
                    }
                }
            }
        }
        .onAppear(){
            loadUserData()
        }
        
    }
    
    // method that loads (more like assigns, loading is done in the viewmodel) all user data
    private func loadUserData() {
        let vm = UserProfileViewModel(modelContext: modelContext)
        userName = vm.userProfile.name
        birthdate = vm.userProfile.birthdate
        activeMinutes = vm.userProfile.activeMinutes % 60
        activeHours = vm.userProfile.activeMinutes/60
        activeEnergy = vm.userProfile.calories
        steps = vm.userProfile.steps
        height = vm.userProfile.height
        weight = vm.userProfile.weight
        userImage = vm.userProfile.image ?? UIImage(resource: .heinrich)
    }
    
    // method that makes sure that no form field stays open after the user is done with editing
    private func closeEdit() {
        isHeightEditPresented = false
        isWeightEditPresented = false
        isBirthdateEditPresented = false
        isActiveTimeEditPresented = false
        isEnergyBurnedEditPresented = false
        isStepsEditPresented = false
    }
    
    // helper method to scroll to a specific item given on the input
    private func scrollToItem(_ id: String, proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(id, anchor: .top)
        }
    }
    
    
    // not very elegant way to ensure that only one form item is open for editing...
    private func resetOtherSelections(except selected: String) {
        switch selected {
        case "Height":
            isWeightEditPresented = false
            isBirthdateEditPresented = false
            isActiveTimeEditPresented = false
            isEnergyBurnedEditPresented = false
            isStepsEditPresented = false
        case "Weight":
            isHeightEditPresented = false
            isBirthdateEditPresented = false
            isActiveTimeEditPresented = false
            isEnergyBurnedEditPresented = false
            isStepsEditPresented = false
        case "Date of Birth":
            isHeightEditPresented = false
            isWeightEditPresented = false
            isActiveTimeEditPresented = false
            isEnergyBurnedEditPresented = false
            isStepsEditPresented = false
        case "Active Time":
            isHeightEditPresented = false
            isWeightEditPresented = false
            isBirthdateEditPresented = false
            isEnergyBurnedEditPresented = false
            isStepsEditPresented = false
        case "Energy Burned":
            isHeightEditPresented = false
            isWeightEditPresented = false
            isBirthdateEditPresented = false
            isActiveTimeEditPresented = false
            isStepsEditPresented = false
        case "Steps":
            isHeightEditPresented = false
            isWeightEditPresented = false
            isBirthdateEditPresented = false
            isActiveTimeEditPresented = false
            isEnergyBurnedEditPresented = false
        default:
            break
        }
    }
}

#Preview {
    UserProfileView()
}

