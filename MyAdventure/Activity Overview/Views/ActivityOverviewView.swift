//
//  ActivityOverviewView.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import SwiftUI
import SwiftData
import HealthKit

struct ActivityOverviewView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext)  var modelContext
    @Query private var myActivities: [Activity]
    @State private var displayedActivities: [Activity] = []
    @EnvironmentObject var manager: HealthManager
    @State private var isLoadingTodayData: Bool = false
    @State var activityToPresent: Activity?
    @StateObject private var vm = ActivityOverviewViewmodel()
    @State private var todaySteps: Int = 0
    @State private var todayStepGoal: Int = 10000
    @State private var todayCalories: Int = 0
    @State private var todayCaloriesGoal: Int = 500
    @State private var todayActiveMinutes: Int = 0
    @State private var todayActiveMinutesGoal: Int = 60
    @State private var todayDistance: Double = 0
    @State private var todayDistaneGoal: Double = 5
    @State private var isPercentageStepsShown = false
    @State private var isPercentageActiveMinutesShown = false
    @State private var isPercentageCaloriesShown = false
    @State private var isPercentageQuestionMarkShown = false
    
    //TODO: Add data from MyActivities to the overview
    
    var body: some View {
        NavigationStack{
            ScrollView {
                switch vm.state {
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    if isLoadingTodayData {
                        ProgressView()
                    } else {
                        contentView
                    }
                case .error:
                    //an empty view is here bcs the error is handled in the viewmodel
                    EmptyView()
                }
            }
            .scrollIndicators(.hidden)
            .refreshable {
                reloadData()
            }
            .onAppear {
                reloadData()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    reloadData()
                }
            }
        }
    }
    
    private var contentView: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("Today's Overview")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal])
                }
                
                if isLoadingTodayData {
                    ProgressView()
                        .padding()
                } else {
                    VStack {
                        HStack {
                            CircleViewStyle(
                                color: .blue,
                                icon: "shoeprints.fill",
                                goal: todayStepGoal,
                                progress: todaySteps,
                                unit: "steps",
                                isPercantageShown: isPercentageStepsShown)
                            .onTapGesture {
                                withAnimation{
                                    isPercentageStepsShown.toggle()
                                }
                            }
                            
                            CircleViewStyle(
                                color: .green,
                                icon: "figure.run",
                                goal: todayActiveMinutesGoal,
                                progress: todayActiveMinutes,
                                unit: "min",
                                isPercantageShown: isPercentageActiveMinutesShown)
                            .onTapGesture {
                                withAnimation{
                                    isPercentageActiveMinutesShown.toggle()
                                }
                            }
                        }
                        HStack {
                            CircleViewStyle(
                                color: .orange,
                                icon: "flame.fill",
                                goal: todayCaloriesGoal,
                                progress: todayCalories,
                                unit: "kcal",
                                isPercantageShown: isPercentageCaloriesShown)
                            .onTapGesture {
                                withAnimation{
                                    isPercentageCaloriesShown.toggle()
                                }
                            }
                            
                            CircleViewStyle(
                                color: .yellow,
                                icon: "questionmark",
                                goal: 0,
                                progress: 0,
                                unit: "",
                                isPercantageShown: isPercentageQuestionMarkShown)
                        }
                    }
                    .padding()
                }
                
                VStack {
                    Text("Recent Activities")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    if displayedActivities.isEmpty {
                        ContentUnavailableView(
                            "No Recent Activities",
                            systemImage: "figure.walk",
                            description: Text("Start your first adventure!")
                        )
                        .padding()
                    } else {
                        VStack {
                            ForEach(displayedActivities) { activity in
                                NavigationLink{
                                    ActivityDetailView(activity: activity)
                                       
                                }label: {
                                    HStack {
                                        ActivityNavigationLinkView(activity: activity)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .padding(.horizontal)
                                    }
                                    .contentShape(Rectangle())
                                    
                                }
                                .foregroundStyle(.primary)
                                .background(.thinMaterial)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func reloadData() {
        let userProfileVM = UserProfileViewModel(modelContext: modelContext)
        let user = userProfileVM.userProfile
        todayStepGoal = user.steps
        todayCaloriesGoal = user.calories
        todayActiveMinutesGoal = user.activeMinutes
        
        Task{
            isLoadingTodayData = true
            await vm.loadActivities()
            displayedActivities = vm.lastWeekActivities + myActivities
            displayedActivities = displayedActivities.sorted { $0.date > $1.date }
            todayActiveMinutes = vm.calculateActiveMinutes()
            
            do {
                todaySteps = try await manager.fetchTodaySteps()
            } catch {
                todaySteps = 0
                print("Authorization or fetch error with steps: \(error.localizedDescription)")
                
            }
            
            do {
                todayCalories = try await manager.fetchTodayCalories()
            } catch {
                todayCalories = 0
                print("Authorization or fetch error with calories: \(error.localizedDescription)")
                
            }
            
            isLoadingTodayData = false
        }
    }
    
    struct CircleViewStyle: View {
        let color: Color
        let icon: String
        let goal: Int
        let progress: Int
        var percantage: Double {
            return Double(progress) / Double(goal)
        }
        let unit: String
        var isPercantageShown: Bool
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: percantage)
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .shadow(radius: 5)
                
                VStack{
                    if isPercantageShown {
                        Text("\(Int(percantage * 100))%")
                            .font(.title)
                    }else {
                        
                        Image(systemName: ("\(icon)"))
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding(.bottom, 5)
                        Text("\(progress) / \(goal) \(unit)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .padding(.horizontal)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                    }
                }
            }
            .padding()
            
        }
    }
    
}

#Preview {
    ActivityOverviewView()
        .environmentObject(HealthManager())
}
