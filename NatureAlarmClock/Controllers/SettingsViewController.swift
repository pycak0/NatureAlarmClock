//
//MARK:  SettingsViewController.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case time, mainSound, additionalSound
        
        func title(_ mode: AlarmMode) -> String {
            switch self {
            case .time:
                return mode == .wakeUp ? "Начало и конец мелодии" : "Длительность мелодии"
            case .mainSound:
                return "Мелодия"
            case .additionalSound:
                return "Дополнительные звуки"
            }
        }
    }

    @IBOutlet weak var settingsCollectionView: UICollectionView!
    var mode: AlarmMode = .sleep
    let hapticsGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var pickedMainSound: Sound!
    var pickedSecondSound: Sound!
    
    var sections = [Section: [Any]]()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(delegate: self, text: mode.message, tintColor: mode.color)
        configureViews()
        configureData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SavedAlarmsManager.general.saveAlarm(mode, currentAlarm: Globals.alarm(mode))
        schdeuleCurrentNotification(mode)
    }
    
    func configureViews() {
        configureCollectionView()
    }
    
    //MARK:- Configure Data
    func configureData() {
        sections = [
            .time : [Globals.alarm(mode).alarmTime],
            .mainSound : SoundsLibrary.getMainSounds(mode),
            .additionalSound : SoundsLibrary.getSecondarySounds(mode)
        ]
        for (section, value) in sections {
            print(section, value)
            value.forEach {
                if let sound = $0 as? Sound {
                    if section == .mainSound, Globals.alarm(mode).mainSoundFileName == sound.fileNamePlusExtension {
                        pickedMainSound = sound
                    } else if section == .additionalSound, Globals.alarm(mode).secondarySoundFileName == sound.fileNamePlusExtension {
                        pickedSecondSound = sound
                    }
                }
            }
        }
        
        AudioHelper.mergeAudios(mainSound: pickedMainSound, secondSound: pickedSecondSound) { (url, error) in
            print(error ?? "success")
        }
        
    }

    func configureCollectionView() {
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func schdeuleCurrentNotification(_ mode: AlarmMode) {
        //MARK:- ‼️Scheduling for wake up only
        guard mode == .wakeUp else {
            return
        }
        let startDate = Globals.alarm(mode).alarmTime.start.dateComponents
        let endDate = Globals.alarm(mode).alarmTime.end.dateComponents
        
        let soundName = Globals.alarm(mode).mixedSoundFileName ?? Globals.alarm(mode).mainSoundFileName
        
        AlarmsManager.general.scheduleNotification(
            alarm: AlarmNotification(mode: mode, title: mode.message, soundFileName: soundName, startDate: startDate, endDate: endDate)
        )
    }
}

//MARK:- Time Cells Delegate
extension SettingsViewController: TimeRangeCellDelegate {
    func timeCell(_ timeCell: TimeRangeCell, didChangeTimeValues startDate: Date, endDate: Date) {
        Globals.alarms[mode]?.alarmTime = AlarmTime(startDate: startDate, endDate: endDate)
        SavedAlarmsManager.general.saveAlarm(mode, currentAlarm: Globals.alarm(mode))
      //  schdeuleCurrentNotification(mode)
    }
}

extension SettingsViewController: TimeDurationCellDelegate {
    func timeDurationCell(_ timeDurationCell: TimeDurationCell, didChangeDurationTo hours: Int, _ minutes: Int) {
        Globals.alarm(mode).alarmTime.start = ClockTime(hour: hours, minute: minutes)
        Globals.alarm(mode).alarmTime.end = ClockTime(hour: hours, minute: minutes)
        
        SavedAlarmsManager.general.saveAlarm(mode, currentAlarm: Globals.alarm(mode))
    }
}

//MARK:- Sound Cell Delegate
extension SettingsViewController: SoundCellDelegate {
    func soundCell(_ soundCell: SoundCell, didReceiveAudioPlaybackError error: Error) {
        print(error)
    }
    
    func soundCell(_ soundCell: SoundCell, didPressPlayButton playButton: UIButton) {
        guard let indexPath = settingsCollectionView.indexPath(for: soundCell),
            let sectionKind = Section(rawValue: indexPath.section) else { return }
        let shouldPlay = !soundCell.isPlaying
        pausePlayers(in: settingsCollectionView, in: sectionKind)
        if shouldPlay {
            soundCell.play()
        }
    }

}

extension SettingsViewController: AlarmNavigationBarViewDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
