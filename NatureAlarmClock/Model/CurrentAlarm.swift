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
    var mainSoundFileName: String
    var secondarySoundFileName: String
    var isSwitchedOn: Bool
    
    init(_ savedAlarm: SavedAlarms.SavedAlarm) {
        self.alarmTime = AlarmTime(startDate: savedAlarm.startDate, endDate: savedAlarm.endDate)
        self.mainSoundFileName = savedAlarm.mainSoundName
        self.secondarySoundFileName = savedAlarm.secondSoundName
        self.isSwitchedOn = savedAlarm.isSwitchedOn
    }
    
    var mixedSound: String? {
        let mainName = URL(string: mainSoundFileName)!.deletingPathExtension().absoluteString
        let secondName = URL(string: secondarySoundFileName)!.deletingPathExtension().absoluteString
        let fullFileName = mainName + secondName + ".m4a"
        
        let url = AudioHelper.soundsDirectory.appendingPathComponent(fullFileName)
        if FileManager.default.fileExists(atPath: url.path) {
            return fullFileName
        }
        return nil
    }
    
    var savedAlarm: SavedAlarms.SavedAlarm {
        let dict = SavedAlarms.general.savedAlarmDict(self)
        return SavedAlarms.SavedAlarm(dict)
    }
    
}
