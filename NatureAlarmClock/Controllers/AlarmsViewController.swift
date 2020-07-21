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
    
    var sleepTime: AlarmTime?
    var wakeUpTime: AlarmTime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(delegate: nil)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSavedTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingsScreen":
            guard let vc = segue.destination as? SettingsViewController,
                let mode = sender as? AlarmMode else { return }
            vc.mode = mode
        default:
            break
        }
    }
    
    private func updateSavedTime() {
        sleepTime = SavedAlarms.general.alarmTime(.sleep)
        wakeUpTime = SavedAlarms.general.alarmTime(.wakeUp)
        
        guard sleepTime != nil, wakeUpTime != nil else { return }
        
        let strSleepTime = sleepTime!.intervalRepresentation
        let strWakeTime = wakeUpTime!.intervalRepresentation
        wakeupAlarmView.time = strWakeTime
        sleepAlarmView.time = strSleepTime
    }
        
    private func configureViews() {
        wakeupAlarmView.time = "7:30 - 8:00"
        sleepAlarmView.time = "23:00 - 00:00"
        updateSavedTime()
        
        wakeupAlarmView.mode = .wakeUp
        wakeupAlarmView.delegate = self
        sleepAlarmView.mode = .sleep
        sleepAlarmView.delegate = self
        
        wakeupAlarmView.isSwitchedOn = false
        sleepAlarmView.isSwitchedOn = false
    }

}

extension AlarmsViewController: AlarmViewDelegate {
    
    func alarmView(_ alarmView: AlarmView, didPressSettingsButton settingsButton: UIButton) {
        performSegue(withIdentifier: "SettingsScreen", sender: alarmView.mode)
    }
    
    func alarmView(_ alarmView: AlarmView, didPressSwitchButton switchButton: UIButton) {
        alarmView.isSwitchedOn.toggle()
    }
    
}
