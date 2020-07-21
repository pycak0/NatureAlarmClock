//
//MARK:  AlarmTime.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct AlarmTime {
    var start: ClockTime
    var end: ClockTime
    
    init(start: ClockTime, end: ClockTime) {
        self.start = start
        self.end = end
    }
    
    init(dateComponentsStart: DateComponents, dateComponentsEnd: DateComponents) {
        self.start = ClockTime(hour: dateComponentsStart.hour!, minute: dateComponentsStart.minute!)
        self.end = ClockTime(hour: dateComponentsEnd.hour!, minute: dateComponentsEnd.minute!)
    }
    
    init(startDate: Date, endDate: Date) {
        self.start = ClockTime(date: startDate)
        self.end = ClockTime(date: endDate)
    }
    
    ///init with start and end times written in format of "HH{separator}mm"
    ///
    ///For example: `AlarmTime(start: "7:30", end: "8:00", separator: ":")`
    init(start: String, end: String, separator: String = ":") {
        self.start = ClockTime(from: start, separatedWith: separator)!
        self.end = ClockTime(from: end, separatedWith: separator)!
    }
    
    
    init(from intervalRepresentation: String, intervalSep: String = " — ", timeSep: String = ":") {
        let parts = intervalRepresentation.components(separatedBy: intervalSep)
        self.init(start: parts.first!, end: parts.last!, separator: timeSep)
    }
    
    var intervalRepresentation: String {
        return "\(start) — \(end)"
    }

}
