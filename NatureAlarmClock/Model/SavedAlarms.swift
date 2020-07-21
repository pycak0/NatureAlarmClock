//
//MARK:  SavedAlarms.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class SavedAlarms {
    //singleton
    private init() {}
    
    static let general = SavedAlarms()
    
    private let defaults = UserDefaults.standard
    
    enum AlarmDateKeys: String {
        case sleepStart, sleepEnd, wakeupStart, wakeupEnd
        case isSleepAlarmSwitchedOn, isWakeAlarmSwitchedOn
        case soundName
    }
    
    private var sleepStartDate: Date? {
        get {
            defaults.value(forKey: AlarmDateKeys.sleepStart.rawValue) as? Date
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.sleepStart.rawValue)
        }
    }
    
    private var sleepEndDate: Date? {
        get {
            defaults.value(forKey: AlarmDateKeys.sleepEnd.rawValue) as? Date
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.sleepEnd.rawValue)
        }
    }
    
    private var wakeupStartDate: Date? {
        get {
            defaults.value(forKey: AlarmDateKeys.wakeupStart.rawValue) as? Date
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.wakeupStart.rawValue)
        }
    }
    
    private var wakeupEndDate: Date? {
        get {
            defaults.value(forKey: AlarmDateKeys.wakeupEnd.rawValue) as? Date
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.wakeupEnd.rawValue)
        }
    }
    
    var isSleepAlarmSwitchedOn: Bool {
        get {
            defaults.bool(forKey: AlarmDateKeys.isSleepAlarmSwitchedOn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.isSleepAlarmSwitchedOn.rawValue)
        }
    }
    
    var isWakeAlarmSwitchedOn: Bool {
        get {
            defaults.bool(forKey: AlarmDateKeys.isWakeAlarmSwitchedOn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: AlarmDateKeys.isWakeAlarmSwitchedOn.rawValue)
        }
    }
    
    func isAlarmSwitchedOn(_ mode: AlarmMode) -> Bool {
        switch mode {
        case .sleep:
            return isSleepAlarmSwitchedOn
        case .wakeUp:
            return isWakeAlarmSwitchedOn
        }
    }
    
    func toggleAlarm(_ mode: AlarmMode) {
        switch mode {
        case .sleep:
            isSleepAlarmSwitchedOn.toggle()
        case .wakeUp:
            isWakeAlarmSwitchedOn.toggle()
        }
    }
    
    //MARK:- Save Dates 
    func saveDates(mode: AlarmMode, startDate: Date, endDate: Date) {
        switch mode {
        case .sleep:
            sleepStartDate = startDate
            sleepEndDate = endDate
        case .wakeUp:
            wakeupStartDate = startDate
            wakeupEndDate = endDate
        }
    }
    
    func startDate(_ mode: AlarmMode) -> Date? {
        switch mode {
        case .sleep:
            return sleepStartDate
        case .wakeUp:
            return wakeupStartDate
        }
    }
    
    func endDate(_ mode: AlarmMode) -> Date? {
        switch mode {
        case .sleep:
            return sleepEndDate
        case .wakeUp:
            return wakeupEndDate
        }
    }
    
    func alarmTime(_ mode: AlarmMode) -> AlarmTime? {
        switch mode {
        case .sleep:
            if let start = sleepStartDate, let end = sleepEndDate {
                return AlarmTime(startDate: start, endDate: end)
            }
        case .wakeUp:
            if let start = wakeupStartDate, let end = wakeupEndDate {
                return AlarmTime(startDate: start, endDate: end)
            }
        }
        return nil
    }
}
