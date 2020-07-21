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
    
    let hapticsGenerator = UIImpactFeedbackGenerator()
    
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
        wakeupAlarmView.time = Globals.alarm(.wakeUp).alarmTime.intervalRepresentation
        sleepAlarmView.time = Globals.alarm(.sleep).alarmTime.intervalRepresentation
    }
    
    private func configureViews() {
        wakeupAlarmView.mode = .wakeUp
        wakeupAlarmView.delegate = self
        wakeupAlarmView.isSwitchedOn = Globals.alarm(.wakeUp).isSwitchedOn
        sleepAlarmView.mode = .sleep
        sleepAlarmView.delegate = self
        sleepAlarmView.isSwitchedOn = Globals.alarm(.sleep).isSwitchedOn
        
        updateSavedTime()
    }

}

extension AlarmsViewController: AlarmViewDelegate {
    
    func alarmView(_ alarmView: AlarmView, didPressSettingsButton settingsButton: UIButton) {
        performSegue(withIdentifier: "SettingsScreen", sender: alarmView.mode)
        //hapticsGenerator.impactOccurred()
    }
    
    func alarmView(_ alarmView: AlarmView, didPressSwitchButton switchButton: UIButton) {
        hapticsGenerator.impactOccurred()
        
        Globals.alarm(alarmView.mode).isSwitchedOn.toggle()
        alarmView.isSwitchedOn.toggle()
        SavedAlarms.general.saveAlarm(alarmView.mode, currentAlarm: Globals.alarm(alarmView.mode))
        
        if Globals.alarm(alarmView.mode).isSwitchedOn {
            
            let startDate = Globals.alarm(alarmView.mode).alarmTime.start.dateComponents
            let endDate = Globals.alarm(alarmView.mode).alarmTime.end.dateComponents
            
            AlarmsManager.general.scheduleNotification(alarm:
                AlarmNotification(mode: alarmView.mode, title: alarmView.mode.message,
                                  soundFileName: Globals.alarm(alarmView.mode).soundFileName,
                                  startDate: startDate, endDate: endDate))
            
        } else {
            AlarmsManager.general.cancelNotitfication(alarmView.mode)
        }
    }
    
}
