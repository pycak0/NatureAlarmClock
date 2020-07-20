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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingsScreen":
            guard let vc = segue.destination as? SettingsViewController,
                let mode = sender as? AlarmView.AlarmMode else { return }
            vc.mode = mode
        default:
            break
        }
    }
    
    private func configureViews() {
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
        performSegue(withIdentifier: "SettingsScreen", sender: alarmView.mode)
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
