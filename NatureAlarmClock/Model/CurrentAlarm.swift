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
    
    var mixedSoundFileName: String? {
        let mainName = URL(string: mainSoundFileName)!.deletingPathExtension().absoluteString
        let secondName = URL(string: secondarySoundFileName)!.deletingPathExtension().absoluteString
        let fullFileName = mainName + secondName + ".m4a"
        
        let url = AudioHelper.soundsDirectory.appendingPathComponent(fullFileName)
        if FileManager.default.fileExists(atPath: url.path) {
            return fullFileName
        }
        return nil
    }
    
    var mixedSoundUrl: URL? {
        guard let fileName = mixedSoundFileName else {
            return nil
        }
        return AudioHelper.soundsDirectory.appendingPathComponent(fileName)
    }
    
    ///Getter firslty checks the `'Bundle'` directory, then `'Library/Sounds'` for the suitable file. If nothing is found, returns `nil`
    var mainSoundUrl: URL? {
        let soundDirectoryUrl = AudioHelper.soundsDirectory.appendingPathComponent(mainSoundFileName)
        if FileManager.default.fileExists(atPath: soundDirectoryUrl.path) {
            return soundDirectoryUrl
        }
        if let ext = URL(string: mainSoundFileName)?.pathExtension,
            let mainSoundName = URL(string: mainSoundFileName)?.deletingPathExtension().lastPathComponent,
            let bundleUrl = Bundle.main.url(forResource: mainSoundName, withExtension: ext) {
                return bundleUrl
        } else { return nil }
    }
    
    var savedAlarm: SavedAlarms.SavedAlarm {
        let dict = SavedAlarms.general.savedAlarmDict(self)
        return SavedAlarms.SavedAlarm(dict)
    }
    
}
