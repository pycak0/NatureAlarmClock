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
        case startDate, endDate, mainSound, secondSound, switchedOn
    }
    
    struct SavedAlarm {
        var startDate: Date
        var endDate: Date
        var mainSoundName: String
        var secondSoundName: String
        var isSwitchedOn: Bool
        
        init(_ dictionary: [String: Any], defaultStartDate: Date = Date()) {
            self.startDate = dictionary[AlarmKeys.startDate.rawValue] as? Date ?? defaultStartDate
            self.endDate = dictionary[AlarmKeys.endDate.rawValue] as? Date ?? Date()
            self.mainSoundName = dictionary[AlarmKeys.mainSound.rawValue] as? String ?? "forestSound.m4r"
            self.secondSoundName = dictionary[AlarmKeys.secondSound.rawValue] as? String ?? "woodpecker.m4r"
            self.isSwitchedOn = dictionary[AlarmKeys.switchedOn.rawValue] as? Bool ?? false
        }
    }
    
    func getAlarm(_ mode: AlarmMode) -> SavedAlarm {
        let dict = defaults.value(forKey: mode.rawValue) as? [String : Any] ?? [:]
        let date = mode == .sleep ? Date().withGivenTime(hours: 0, minutes: 30) : Date()
        return SavedAlarm(dict, defaultStartDate: date)
    }
    
    func saveAlarm(_ mode: AlarmMode, alarm: SavedAlarm) {
        let dict = savedAlarmDict(alarm)
        defaults.set(dict, forKey: mode.rawValue)
    }
    
    func saveAlarm(_ mode: AlarmMode, currentAlarm: CurrentAlarm) {
        let dict = savedAlarmDict(currentAlarm)
        defaults.set(dict, forKey: mode.rawValue)
        print("Current alarm is saved")
    }
    
    func savedAlarmDict(_ savedAlarm: SavedAlarm) -> [String: Any] {
        let current = CurrentAlarm(savedAlarm)
        return savedAlarmDict(current)
    }
    
    func savedAlarmDict(_ currentAlarm: CurrentAlarm) -> [String: Any] {
        return [
            AlarmKeys.startDate.rawValue : currentAlarm.alarmTime.start.date,
            AlarmKeys.endDate.rawValue : currentAlarm.alarmTime.end.date,
            AlarmKeys.mainSound.rawValue : currentAlarm.mainSoundFileName,
            AlarmKeys.secondSound.rawValue : currentAlarm.secondarySoundFileName,
            AlarmKeys.switchedOn.rawValue : currentAlarm.isSwitchedOn
        ]
    }
    
}
