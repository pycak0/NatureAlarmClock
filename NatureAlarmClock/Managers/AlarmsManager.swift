//
//MARK:  AlarmsManager.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import UserNotifications
import AVKit

class AlarmsManager {
    //singleton
    private init() {}
    
    static let general = AlarmsManager()
        
    func scheduleNotification(alarm: AlarmNotification) {
        guard Globals.alarm(alarm.mode).isSwitchedOn else {
            print("Alarm mode '\(alarm.mode)' is switched off")
            return
        }
        cancelPendingNotifications(alarm.mode) {
            self.schedule(alarm)
        }
    }
    
    ///Executes on a second thread
    private func schedule(_ alarm: AlarmNotification) {
        print("Setting Notification with sound: \(alarm.soundFileName)")
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: alarm.startDate),
            let endDate = calendar.date(from: alarm.endDate) else {
                print("Error setting alarm")
                return
        }
        
        let interval = endDate.timeIntervalSince(startDate)
        var secondsPerNotification = 8
//        if interval <= 16 * TimeInterval.secondsIn(.minute) {
//            secondsPerNotification = 15
//        }
        let repeatTimes = Int(interval) / secondsPerNotification
//        secondsPerNotification = interval / (repeatTimes - 8)
//
//        func notificationTime(for iteration: Int, of totalTimes: Int) -> TimeInterval {
//            if 0 <= iteration && iteration < 4 || totalTimes - 4 <= iteration && iteration < totalTimes {
//                return TimeInterval(15)
//            }
//            return TimeInterval(secondsPerNotification)
//        }
        // Get user notification settings. Might be useful
        // UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        //      settings.alertStyle == .banner
        // }
        DispatchQueue.global(qos: .userInitiated).async {
            for iteration in 0..<repeatTimes {
                
                let content = UNMutableNotificationContent()
                content.title = alarm.title
                //content.sound = .default
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: alarm.soundFileName))
                
                let date = startDate.addingTimeInterval(TimeInterval(iteration * secondsPerNotification))
                let components = calendar.dateComponents([.hour, .minute, .second], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: alarm.mode.rawValue + "\(iteration)", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    print("Notification with id '\(request.identifier)' scheduled successfully")
                }
            }
        }
    }
    
    func cancelAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    ///- parameter handler: A block to execute after all notifications are cancelled
    func cancelPendingNotifications(_ mode: AlarmMode, handler: (() -> Void)? = nil) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            var removeIDs = [String]()
            requests.forEach {
                let id = $0.identifier
                if id.contains(mode.rawValue) {
                    print("Removing notification request with id '\(id)'")
                    removeIDs.append(id)
                }
            }
            DispatchQueue.global().sync {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIDs)
            }
            handler?()
        }
    }
    
}
