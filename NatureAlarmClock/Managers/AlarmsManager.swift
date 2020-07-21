//
//MARK:  AlarmsManager.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmsManager {
    //singleton
    private init() {}
    
    static let general = AlarmsManager()
    
    // var alarms = [AlarmNotification]()
    
    func scheduleNotification(alarm: AlarmNotification) {
        guard Globals.alarm(alarm.mode).isSwitchedOn else {
            print("Alarm mode '\(alarm.mode)' is switched off")
            return
        }
        
        print("Setting Notification with sound: \(alarm.soundFileName)")
        
        let content = UNMutableNotificationContent()
        content.title = alarm.title
        //content.sound = .default
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: alarm.soundFileName))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarm.startDate, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.mode.rawValue, content: content, trigger: trigger)
        
//        var newDate = alarm.startDate
//        newDate.minute = newDate.minute! + 1
//        let newTrigger = UNCalendarNotificationTrigger(dateMatching: newDate, repeats: false)
//        let newRequest = UNNotificationRequest(identifier: "wakeUp1", content: content, trigger: newTrigger)
//
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            settings.alertStyle == .banner
//        }
//
        UNUserNotificationCenter.current().add(request) { (error) in
            guard error == nil else {
                print(error!)
                return
            }
            print("Notification with id '\(request.identifier)' scheduled successfully")
        }
        
       // UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: nil)
    }
    
    
    func cancelNotitfication(_ mode: AlarmMode) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [mode.rawValue])
    }
    
}
