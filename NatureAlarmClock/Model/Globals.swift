//
//  Globals.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class Globals {
    private init() {}
    
    static var sleepAlarm: CurrentAlarm!
    static var wakeUpAlarm: CurrentAlarm!
    
    static var alarms: [AlarmMode: CurrentAlarm] = [
        .sleep : sleepAlarm,
        .wakeUp : wakeUpAlarm
    ]
    
    static func alarm(_ mode: AlarmMode) -> CurrentAlarm {
        switch mode {
        case .sleep:
            return sleepAlarm
        case .wakeUp:
            return wakeUpAlarm
        }
    }
    
    static func setAlarm(_ mode: AlarmMode, value: CurrentAlarm) {
        switch mode {
        case .sleep:
            sleepAlarm = value
        case .wakeUp:
            wakeUpAlarm = value
        }
    }
    
   // static var player: AVAudioPlayer?
    
}
