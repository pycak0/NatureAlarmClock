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
    
    enum AlarmKeys: String {
        case startDate, endDate, soundName, switchedOn
    }
    
    struct SavedAlarm {
        var startDate: Date
        var endDate: Date
        var soundName: String
        var isSwitchedOn: Bool
        
        init(_ dictionary: [String: Any]) {
            self.startDate = dictionary[AlarmKeys.startDate.rawValue] as? Date ?? Date()
            self.endDate = dictionary[AlarmKeys.endDate.rawValue] as? Date ?? Date()
            self.soundName = dictionary[AlarmKeys.soundName.rawValue] as? String ?? "forestSound.m4r"
            self.isSwitchedOn = dictionary[AlarmKeys.switchedOn.rawValue] as? Bool ?? false
        }
    }
    
    func getAlarm(_ mode: AlarmMode) -> SavedAlarm {
        let dict = defaults.value(forKey: mode.rawValue) as? [String : Any] ?? [:]
        return SavedAlarm(dict)
    }
    
    func saveAlarm(_ mode: AlarmMode, alarm: SavedAlarm) {
        let dict: [String: Any] = [
            AlarmKeys.startDate.rawValue : alarm.startDate,
            AlarmKeys.endDate.rawValue : alarm.endDate,
            AlarmKeys.soundName.rawValue : alarm.soundName
        ]
        defaults.set(dict, forKey: mode.rawValue)
    }
    
    func saveAlarm(_ mode: AlarmMode, currentAlarm: CurrentAlarm) {
        let dict: [String: Any] = [
            AlarmKeys.startDate.rawValue : currentAlarm.alarmTime.start.date,
            AlarmKeys.endDate.rawValue : currentAlarm.alarmTime.end.date,
            AlarmKeys.soundName.rawValue : currentAlarm.soundFileName,
            AlarmKeys.switchedOn.rawValue : currentAlarm.isSwitchedOn
        ]
        defaults.set(dict, forKey: mode.rawValue)
        print("Current alarm is saved")
    }
    
    func saveAlarm(_ mode: AlarmMode, startDate: Date, endDate: Date, soundName: String, isSwitchedOn: Bool) {
        let dict: [String: Any] = [
            AlarmKeys.startDate.rawValue : startDate,
            AlarmKeys.endDate.rawValue : endDate,
            AlarmKeys.soundName.rawValue : soundName,
            AlarmKeys.switchedOn.rawValue : isSwitchedOn
        ]
        defaults.set(dict, forKey: mode.rawValue)
    }
    
}
