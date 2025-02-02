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
    @EnvironmentObject var manager: HealthManager
    @State var activityToPresent: Activity?
    @State private var isActivityDetailPresented = false
    @State private var lastWeekActivities: [Activity] = []
    @State private var vm = ActivityOverviewViewmodel()
    @State private var todaySteps: Int = 0
    @State private var todayStepGoal: Int = 10000
    @State private var todayCalories: Int = 0
    @State private var todayCaloriesGoal: Int = 500
    @State private var todayActiveMinutes: Int = 0
    @State private var todayActiveMinutesGoal: Int = 60
    @State private var todayDistance: Double = 0
    @State private var todayDistaneGoal: Double = 5
    
    
    var body: some View {
        ScrollView{
                VStack{
                    HStack{
                        Text("Today's Overview")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .horizontal])
                    }
                    
                    VStack{
                        HStack{
                            
                            CircleViewStyle(color: .blue, icon: "shoeprints.fill", goal: todayStepGoal, progress: todaySteps, unit: "steps")
                            CircleViewStyle(color: .green, icon: "figure.run", goal: todayActiveMinutesGoal, progress: todayActiveMinutes, unit: "min")
                        }
                        HStack {
                            CircleViewStyle(color: .orange, icon: "flame.fill", goal: todayCaloriesGoal, progress: todayCalories, unit: "kcal")
                            CircleViewStyle(color: .yellow, icon: "questionmark", goal: 0, progress: 0, unit: "")
                        }

                    }
                    .padding()
         
                }
                VStack{
                    Text("Recent Activities")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack {
                        if lastWeekActivities.isEmpty {
                   
                            ContentUnavailableView(
                                "No Recent Activities",
                                systemImage: "figure.walk",
                                description: Text("Start your first adventure!")
                            )
                            .padding()
            
                            
                        } else {
                            VStack {
                                ForEach(lastWeekActivities) { activity in
                                    HStack{
                                        ActivityNavigationLinkView(activity: activity)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .padding(.horizontal)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        activityToPresent = activity
                                        isActivityDetailPresented = true
                                    }
                                }
                                .background(.thinMaterial)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                                
                            }
                            .sheet(item: $activityToPresent, content: { activity in
                                ActivityDetailView(activity: activity)
                                    .presentationDetents([.medium])
                            })
                        }
                    }
                }
        }
        .refreshable {
            reloadData()
        }
        .onAppear {
            reloadData()
        }
    }
    
    private func reloadData() {
        Task {
            await vm.loadActivities()
            lastWeekActivities = vm.lastWeekActivities
            todaySteps = try await manager.fetchTodaySteps()
            todayCalories = try await manager.fetchTodayCalories()
            todayActiveMinutes = vm.calculateActiveMinutes()
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
            .padding()
            
        }
    }
    
}

#Preview {
    ActivityOverviewView()
        .environmentObject(HealthManager())
}
