//
//MARK:  AlarmsViewController.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController {
    
    @IBOutlet weak var wakeupAlarmView: AlarmView!
    @IBOutlet weak var sleepAlarmView: AlarmView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView()
        
        configureViews()
    }
    
    func configureViews() {
        wakeupAlarmView.mode = .wakeUp
        wakeupAlarmView.time = "7:30 - 8:00"
        wakeupAlarmView.delegate = self
        sleepAlarmView.mode = .sleep
        sleepAlarmView.time = "23:00 - 00:00"
        sleepAlarmView.delegate = self
    }

}

extension AlarmsViewController: AlarmViewDelegate {
    
    func alarmView(_ alarmView: AlarmView, didPressSettingsButton settingsButton: UIButton) {
        print("settings button pressed")
    }
    
    func alarmView(_ alarmView: AlarmView, didPressSwitchButton switchButton: UIButton) {
        print("switch button pressed")
        if switchButton.tintColor == .systemRed {
            switchButton.imageView?.tintColor = .systemGreen
        } else {
            switchButton.imageView?.tintColor = .systemRed
        }
    }
    
}
