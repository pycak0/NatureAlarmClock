//
//MARK:  AlarmsViewController.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVKit
import UserNotifications

class AlarmsViewController: UIViewController {
    
    @IBOutlet weak var wakeupAlarmView: AlarmView!
    @IBOutlet weak var sleepAlarmView: AlarmView!
    
    var sleepTime: AlarmTime?
    var wakeUpTime: AlarmTime?
    var player: AVAudioPlayer?
    var timer: Timer? = nil

    let hapticsGenerator = UIImpactFeedbackGenerator()

    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNotificationSettings()
        
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
            stopPlayer()
            vc.mode = mode
        default:
            break
        }
    }
    
    private func updateSavedTime() {
        wakeupAlarmView.time = Globals.alarm(.wakeUp).alarmTime.intervalRepresentation
        sleepAlarmView.time = Globals.alarm(.sleep).alarmTime.start.fullString
    }
    
    //MARK:- Configure Views
    private func configureViews() {
        wakeupAlarmView.mode = .wakeUp
        wakeupAlarmView.delegate = self
        wakeupAlarmView.isSwitchedOn = Globals.alarm(.wakeUp).isSwitchedOn
        sleepAlarmView.mode = .sleep
        sleepAlarmView.delegate = self
        sleepAlarmView.isSwitchedOn = Globals.alarm(.sleep).isSwitchedOn
       // sleepAlarmView.setSwitchButtonImage(UIImage(named: "Play"))
        
        updateSavedTime()
    }
    
    private func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case.notDetermined:
                    self.performSegue(withIdentifier: "Notifications Banner", sender: nil)
                default:
                    break
                }
            }
        }
    }
    
    //MARK:- Schedule Alarm
    private func manageAlarm(_ mode: AlarmMode) {
        guard Globals.alarm(mode).isSwitchedOn else {
            AlarmsManager.general.cancelPendingNotifications(mode)
            self.stopPlayer()
            return
        }
        
        if mode == .sleep {
            startPlayer(mode)
        } else {
            //MARK:- ‼️Scheduling for wake up only
            let startDate = Globals.alarm(mode).alarmTime.start.dateComponents
            let endDate = Globals.alarm(mode).alarmTime.end.dateComponents
            let soundName = Globals.alarm(mode).mixedSoundFileName ?? Globals.alarm(mode).mainSoundFileName
            
            AlarmsManager.general.scheduleNotification(alarm:
                AlarmNotification(mode: mode, title: mode.message,
                                  soundFileName: soundName,
                                  startDate: startDate, endDate: endDate))
        }
        
    }

}

//MARK:- AlarmView Delegate
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
        manageAlarm(alarmView.mode)
    }
    
}

//MARK:- AudioHelper Delegate
extension AlarmsViewController: AudioHelperDelegate {
    func audioHelper(didFinishExportSession exportSession: AVAssetExportSession, with error: ExportError?, or url: URL?) {
        print(url ?? "no url")
        print(error ?? "success")
    }
    
}
