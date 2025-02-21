//
//  UserProfileView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI

struct UserProfileView: View {
    
    @State var isHeightEditPresented = false
    @State var isWeightEditPresented = false
    @State var isBirthdateEditPresented = false
    @State var isActiveTimeEditPresented = false
    @State var isEnergyBurnedEditPresented = false
    @State var isStepsEditPresented = false
    
    @State var birthdate: Date = Date()
    @State var activeMinutes = 20
    @State var activeHours = 1
    @State var activeEnergy = 500
    @State var steps = 20
    @State var height = 175
    @State var weight = 65
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ZStack {
                        Circle()
                            .fill(.gray)
                            .frame(width: 200, height: 200)
                            .opacity(0.5)
                        Image(systemName: "person.fill")
                            .font(.system(size: 100))
                        Image("heinrich")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                    Text("Heinrich")
                        .font(.largeTitle)
                }
                
                VStack {
                    HStack {
                        Text("Info:")
                        Spacer()
                    }
                    
                    ClickableFormItemView(isSelectionPresented: $isHeightEditPresented, itemName: "Height", itemData: "\(height) cm") {
                        HeightWeightSelectionView(selectedValue: $height, isSelectionPresented: $isHeightEditPresented, isHeight: true)
                            .onAppear {
                                withAnimation(.smooth) {
                                    resetOtherSelections(except: "Height")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        scrollToItem("Height", proxy: proxy)
                                    }
                                }
                            }
                    }
                    .id("Height")
                    
                    ClickableFormItemView(isSelectionPresented: $isWeightEditPresented, itemName: "Weight", itemData: "\(weight) kg") {
                        HeightWeightSelectionView(selectedValue: $weight, isSelectionPresented: $isWeightEditPresented)
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
                    
                    ClickableFormItemView(isSelectionPresented: $isBirthdateEditPresented, itemName: "Date of Birth", itemData: "\(birthdate.formatted(date: .numeric, time: .omitted))") {
                        DateSelectionView(selectedDate: $birthdate, isSelectionPresented: $isBirthdateEditPresented)
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
                        Text("Goals:")
                        Spacer()
                    }
                    
                    ClickableFormItemView(isSelectionPresented: $isStepsEditPresented, itemName: "Steps", itemData: String(steps * 500).formattedWithSpaces()) {
                        StepsSelectionView(selectedSteps: $steps, isSelectionPresented: $isStepsEditPresented)
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
                    
                    ClickableFormItemView(isSelectionPresented: $isActiveTimeEditPresented, itemName: "Active Time", itemData: "\(activeHours * 60 + activeMinutes * 10) min") {
                        DurationSelectionView(selectedHours: $activeHours, selectedMinutes: $activeMinutes, isSelectionPresented: $isActiveTimeEditPresented)
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
                    
                    ClickableFormItemView(isSelectionPresented: $isEnergyBurnedEditPresented, itemName: "Energy Burned", itemData: String(activeEnergy * 10).formattedWithSpaces() + " kcal") {
                        ActiveEnergySelectionView(selectedKcal: $activeEnergy, isSelectionPresented: $isEnergyBurnedEditPresented)
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
            .padding()
        }
    }
    
    private func scrollToItem(_ id: String, proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(id, anchor: .top)
        }
    }
    
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

extension String {
    func formattedWithSpaces() -> String {
        let cleanedString = self.replacingOccurrences(of: " ", with: "")
        let reversedString = String(cleanedString.reversed())
        var result = ""
        for (index, character) in reversedString.enumerated() {
            if index != 0 && index % 3 == 0 {
                result.append(" ")
            }
            result.append(character)
        }
        return String(result.reversed())
    }
}
