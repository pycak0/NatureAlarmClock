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
        
        var title: String {
            switch self {
            case .time:
                return "Начало и конец мелодии"
            case .mainSound:
                return "Основная мелодия"
            case .additionalSound:
                return "Дополнительные звуки"
            }
        }
    }

    @IBOutlet weak var settingsCollectionView: UICollectionView!
    var mode: AlarmMode!
    let hapticsGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var sections: [Section: [Any]] = [
        .time : [
            AlarmTime(start: "7:30", end: "8:00")
        ],
        .mainSound : [
            Sound(name: "Лес", file: "forestSound", withExtension: "m4r"),
            Sound(name: "Дождь", file: "rain", withExtension: "mp3"),
            Sound(name: "Прибой", file: "seaSurf", withExtension: "mp3"),
            Sound(name: "Река", file: "river", withExtension: "mp3"),
            Sound(name: "Ночь", file: "Night", withExtension: "mp3")
        ],
        .additionalSound : [
            //Sound(name: "Чайка", file: "", withExtension: ""),
            //Sound(name: "Дятел", file: "", withExtension: ""),
            Sound(name: "Пока не доступно", file: "", withExtension: "")
        ]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(delegate: self, text: mode.message, tintColor: mode.color)
        configureViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SavedAlarms.general.saveAlarm(mode, currentAlarm: Globals.alarm(mode))
    }
    
    func configureViews() {
        configureCollectionView()
        sections[.time] = [Globals.alarm(mode).alarmTime]
    }
    
    func configureCollectionView() {
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func schdeuleCurrentNotification(_ mode: AlarmMode) {
        let startDate = Globals.alarm(mode).alarmTime.start.dateComponents
        let endDate = Globals.alarm(mode).alarmTime.end.dateComponents
        
        AlarmsManager.general.scheduleNotification(
            alarm: AlarmNotification(mode: mode, title: mode.message, soundFileName: Globals.alarm(mode).soundFileName, startDate: startDate, endDate: endDate)
        )
    }
}

//MARK:- Time Cell Delegate
extension SettingsViewController: TimeCellDelegate {
    func timeCell(_ timeCell: TimeCell, didChangeTimeValues startDate: Date, endDate: Date) {
        Globals.alarms[mode]?.alarmTime = AlarmTime(startDate: startDate, endDate: endDate)
        schdeuleCurrentNotification(mode)
    }
    
}

extension SettingsViewController: SoundCellDelegate {
    func soundCell(_ soundCell: SoundCell, didReceiveAudioPlaybackError error: Error) {
        print(error)
    }
    
    func soundCell(_ soundCell: SoundCell, didPressPlayButton playButton: UIButton) {
        guard let indexPath = settingsCollectionView.indexPath(for: soundCell),
            let sectionKind = Section(rawValue: indexPath.section) else { return }
        let shouldPlay = !soundCell.isPlaying
        pausePlayers(in: settingsCollectionView, at: sectionKind)
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
