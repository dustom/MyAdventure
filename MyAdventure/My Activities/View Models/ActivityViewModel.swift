//
//  ActivityNavigationLinkViewModel.swift
//  MyAdventure
//
//  Created by Tomáš Dušek on 29.01.2025.
//

import Foundation

class ActivityViewModel {
     func formatDuration(_ minutes: Int) -> String {
        if minutes >= 120 {
            let hours = Double(minutes) / 60.0
            // Show as integer if whole number
            return hours.truncatingRemainder(dividingBy: 1) == 0 ?
                "\(Int(hours)) h" :
                String(format: "%.1f h", hours)
        }
        return "\(minutes) min"
    }
    
     func calculateRate(activity: Activity) -> String {
        guard activity.distance > 0 else { return "" }
        
        let type = activity.activityType.lowercased()
        let minutes = Double(activity.duration)
        let distance = activity.distance
        
         if distance > 0 && minutes > 0 {
             if ["running", "hiking"].contains(type) {
                 let paceMinutes = minutes / distance
                 let seconds = (paceMinutes.truncatingRemainder(dividingBy: 1) * 60).rounded()
                 return String(format: "%d:%02d min/km", Int(paceMinutes), Int(seconds))
             }
             else
             
             {
                 let hours = minutes / 60.0
                 let speed = distance / hours
                 return String(format: "%.1f km/h", speed)
             }
         } else {
             return ""
         }
    }
    
     func getActivityIcon(for activityType: String) -> String {
         switch activityType.lowercased() {
        case "running": return "figure.run"
        case "cycling": return "figure.outdoor.cycle"
        case "swimming": return "figure.pool.swim"
        case "hiking": return "figure.hiking"
        default: return "figure.walk"
        }
    }
}
