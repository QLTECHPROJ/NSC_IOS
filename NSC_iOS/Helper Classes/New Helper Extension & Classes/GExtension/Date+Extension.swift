//
//  Date+Extension.swift
//  NSC_iOS
//
//  Created by vishal parmar on 05/10/23.
//

import Foundation
//-------------------------------------------------------------------
//MARK:- Date Extension
//-------------------------------------------------------------------
extension Date {
    
    var yearsFromNow:   Int { return Calendar.current.dateComponents([.year],       from: self, to: Date()).year        ?? 0 }
    var monthsFromNow:  Int { return Calendar.current.dateComponents([.month],      from: self, to: Date()).month       ?? 0 }
    var weeksFromNow:   Int { return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear  ?? 0 }
    var daysFromNow:    Int { return Calendar.current.dateComponents([.day],        from: self, to: Date()).day         ?? 0 }
    var hoursFromNow:   Int { return Calendar.current.dateComponents([.hour],       from: self, to: Date()).hour        ?? 0 }
    var minutesFromNow: Int { return Calendar.current.dateComponents([.minute],     from: self, to: Date()).minute      ?? 0 }
    var secondsFromNow: Int { return Calendar.current.dateComponents([.second],     from: self, to: Date()).second      ?? 0 }
    
    
    var relativeTime: String {
        
        if yearsFromNow   > 0 { return "\(yearsFromNow) Year"    + (yearsFromNow    > 1 ? "s" : "") + " ago" }
        if monthsFromNow  > 0 { return "\(monthsFromNow) Month"  + (monthsFromNow   > 1 ? "s" : "") + " ago" }
        if weeksFromNow   > 0 { return "\(weeksFromNow) Week"    + (weeksFromNow    > 1 ? "s" : "") + " ago" }
        
        
        //        if weeksFromNow == 1{
        //            return "\(weeksFromNow) Week ago"
        //        }else if weeksFromNow > 1{
        //
        //            let format = DateFormatter()
        //            format.dateFormat = "dd-MMM-yyyy"
        //            let dat = format.string(from: self)
        //            return "\(dat)"
        //        }
        
        if daysFromNow    > 0 {
            let calendar = Calendar.current
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: self)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let dayCount = components.day{
                return dayCount == 1 ? "Yesterday" : "\(dayCount) Days ago"
                
            }else{
                return "\(daysFromNow) Days ago"
                
            }
            
        }
        
        if hoursFromNow   > 0 { return "\(hoursFromNow) Hr"     + (hoursFromNow   > 1 ? "s" : "") + " ago" }
        if minutesFromNow > 0 { return "\(minutesFromNow) Min" + (minutesFromNow > 1 ? "s" : "") + " ago" }
        if secondsFromNow > 0 { return secondsFromNow < 15 ? "Just now"            : "\(secondsFromNow) Sec" + (secondsFromNow > 1 ? "s" : "") + " ago"
            
        }
        return ""
    }
    
    
    var relativeLikeTime: String {
        
        if yearsFromNow   > 0 { return "\(yearsFromNow) yr"    + (yearsFromNow    > 1 ? "s" : "")}
        if monthsFromNow  > 0 { return "\(monthsFromNow) mn"  + (monthsFromNow   > 1 ? "s" : "")}
        if weeksFromNow   > 0 { return "\(weeksFromNow) w"    + (weeksFromNow    > 1 ? "" : "")}
        
        
        //        if weeksFromNow == 1{
        //            return "\(weeksFromNow) Week ago"
        //        }else if weeksFromNow > 1{
        //
        //            let format = DateFormatter()
        //            format.dateFormat = "dd-MMM-yyyy"
        //            let dat = format.string(from: self)
        //            return "\(dat)"
        //        }
        
        if daysFromNow    > 0 {
            let calendar = Calendar.current
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: self)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let dayCount = components.day{
                //                return dayCount == 1 ? "Yesterday" : "\(dayCount) Days ago"
                
                //            }else{
                return "\(daysFromNow) d"
                
            }
            
        }
        
        if hoursFromNow   > 0 { return "\(hoursFromNow) h"     + (hoursFromNow   > 1 ? "" : "")}
        if minutesFromNow > 0 { return "\(minutesFromNow) m" + (minutesFromNow > 1 ? "" : "")}
        if secondsFromNow > 0 { return secondsFromNow < 15 ? "just now"  : "\(secondsFromNow) s" + (secondsFromNow > 1 ? "" : "")}
        return ""
    }
    
    
    var relativeUserActiveTime: String {
        
        if yearsFromNow   > 0 { return "Active \(yearsFromNow) yr"    + (yearsFromNow    > 1 ? "s" : "") + " ago" }
        if monthsFromNow  > 0 { return "Active \(monthsFromNow) Month"  + (monthsFromNow   > 1 ? "s" : "") + " ago" }
        if weeksFromNow   > 0 { return "Active \(weeksFromNow) w"    + (weeksFromNow    > 1 ? "s" : "") + " ago" }
        
        
        //        if weeksFromNow == 1{
        //            return "\(weeksFromNow) Week ago"
        //        }else if weeksFromNow > 1{
        //
        //            let format = DateFormatter()
        //            format.dateFormat = "dd-MMM-yyyy"
        //            let dat = format.string(from: self)
        //            return "\(dat)"
        //        }
        
        if daysFromNow    > 0 {
            let calendar = Calendar.current
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: self)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let dayCount = components.day{
                return dayCount == 1 ? "Active Yesterday" : "\(dayCount) days ago"
                
            }else{
                return "Active \(daysFromNow) days ago"
                
            }
            
        }
        
        if hoursFromNow   > 0 { return "Active \(hoursFromNow) h"     + (hoursFromNow   > 1 ? "s" : "") + " ago" }
        if minutesFromNow > 0 { return "Active \(minutesFromNow) m" + (minutesFromNow > 1 ? "s" : "") + " ago" }
        if secondsFromNow > 0 { return secondsFromNow < 30 ? "Active now" : "Active \(secondsFromNow) sec" + (secondsFromNow > 1 ? "s" : "") + " ago"
            
        }
        return ""
    }
}
