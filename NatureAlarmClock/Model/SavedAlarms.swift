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
    
    enum AlarmDateKeys: String {
        case sleepStart, sleepEnd, wakeupStart, wakeupEnd
    }
    
    var sleepStartDate: Date? {
        get {
            UserDefaults.standard.value(forKey: AlarmDateKeys.sleepStart.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AlarmDateKeys.sleepStart.rawValue)
        }
    }
    
    var sleepEndDate: Date? {
        get {
            UserDefaults.standard.value(forKey: AlarmDateKeys.sleepEnd.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AlarmDateKeys.sleepEnd.rawValue)
        }
    }
    
    var wakeupStartDate: Date? {
        get {
            UserDefaults.standard.value(forKey: AlarmDateKeys.wakeupStart.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AlarmDateKeys.wakeupStart.rawValue)
        }
    }
    
    var wakeupEndDate: Date? {
        get {
            UserDefaults.standard.value(forKey: AlarmDateKeys.wakeupEnd.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AlarmDateKeys.wakeupEnd.rawValue)
        }
    }
    
}
