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
    
    var string: String {
        return String(format: "%02d:%02d", hour, minute)
    }
}
