//
//MARK:  ClockTime.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ClockTime {
    var hour: Int
    var minute: Int
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    init(date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        self.hour = components.hour!
        self.minute = components.minute!
    }
    
    init?(from string: String, separatedWith sep: String) {
        let rawData = string.components(separatedBy: sep).map { Int($0) }
        if let hour = rawData.first as? Int, let minute = rawData.last as? Int {
            self.hour = hour
            self.minute = minute
        }
        else {
            return nil
        }
    }
    
    var shortString: String {
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var fullString: String {
        hour > 0 ? String(format: "%d ч %02d мин", hour, minute) : "\(minute) мин"
    }
    
    var date: Date {
        var components = DateComponents()
        components.timeZone = .current
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
    
    var dateComponents: DateComponents {
        var components = DateComponents()
        components.timeZone = .current
        components.hour = hour
        components.minute = minute
        return components
    }
    
    ///Represents `ClockTime` object's amount of `hour` + `minute`  in seconds
    var timeInterval: TimeInterval {
        TimeInterval.secondsIn(.hour, amount: hour) + TimeInterval.secondsIn(.minute, amount: minute)
    }
}
