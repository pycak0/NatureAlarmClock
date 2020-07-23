//
//  NotificationsBannerVC.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsBannerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func turnOnButtonPressed(_ sender: UIButton) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, error in
            
            DispatchQueue.main.async {
                if !granted {
                    print("not granted")
                }
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    

}
