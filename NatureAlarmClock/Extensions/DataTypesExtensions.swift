//
//MARK:  DataTypesExtensions.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Date
extension Date {
    /// Returns Today's date without time (set to 00:00:00)
    ///
    ///- warning: For the correct representation of the date "`TimeZone.current`" must be used
    var withoutTime: Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        dateComponents.timeZone = .current
        return calendar.date(from: dateComponents)!
    }
    
    ///- returns: Today's date with given time in hours and minutes
    func withGivenTime(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.timeZone = .current
        
        return calendar.date(from: dateComponents)!
    }
}


extension TimeInterval {
    enum TimeIntervalNames {
        case minute, hour, day, week, year, leapYear
        
        var seconds: Double {
            switch self {
            case .minute:
                return 60
            case .hour:
                return 60 * 60
            case .day:
                return 24 * 60 * 60
            case .week:
                return 7 * 24 * 60 * 60
            case .year:
                return 365 * 24 * 60 * 60
            case .leapYear:
                return 366 * 24 * 60 * 60
            }
        }
    }
    
    
    //MARK:- Seconds In
    ///Returns time interval in seconds for widely-used types of time
    static func secondsIn(_ time: TimeIntervalNames, amount: Int = 1) -> TimeInterval {
        return time.seconds * Double(amount)
    }
    
    static func secondsIn(_ time: TimeIntervalNames, amount: Double = 1) -> TimeInterval {
        return time.seconds * (amount)
    }
    
    static func secondsIn(_ time: TimeIntervalNames, amount: CGFloat = 1) -> TimeInterval {
        return time.seconds * Double(amount)
    }
}
