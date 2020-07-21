//
//  CurrentAlarm.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class CurrentAlarm {
    var alarmTime: AlarmTime
    var soundFileName: String
    var isSwitchedOn: Bool
    
    init(_ savedAlarm: SavedAlarms.SavedAlarm) {
        self.alarmTime = AlarmTime(startDate: savedAlarm.startDate, endDate: savedAlarm.endDate)
        self.soundFileName = savedAlarm.soundName
        self.isSwitchedOn = savedAlarm.isSwitchedOn
    }
    
    var savedAlarm: SavedAlarms.SavedAlarm {
        SavedAlarms.SavedAlarm([
            SavedAlarms.AlarmKeys.startDate.rawValue: alarmTime.start.date,
            SavedAlarms.AlarmKeys.endDate.rawValue: alarmTime.end.date,
            SavedAlarms.AlarmKeys.soundName.rawValue: soundFileName,
            SavedAlarms.AlarmKeys.switchedOn.rawValue: isSwitchedOn
        ])
    }
}
