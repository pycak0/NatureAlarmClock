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
    
    var pickedMainSound: Sound!
    var pickedSecondSound: Sound!
    
    var sections = [Section: [Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(delegate: self, text: mode.message, tintColor: mode.color)
        configureViews()
        configureData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SavedAlarms.general.saveAlarm(mode, currentAlarm: Globals.alarm(mode))
        schdeuleCurrentNotification(mode)
    }
    
    func configureViews() {
        configureCollectionView()
    }
    
    func configureData() {
        sections = [
            .time : [
                Globals.alarm(mode).alarmTime
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
                Sound(name: "Дятел", file: "woodpecker", withExtension: "m4r")
            ]
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
        let startDate = Globals.alarm(mode).alarmTime.start.dateComponents
        let endDate = Globals.alarm(mode).alarmTime.end.dateComponents
        
        let soundName = Globals.alarm(mode).mixedSound ?? Globals.alarm(mode).mainSoundFileName
        
        AlarmsManager.general.scheduleNotification(
            alarm: AlarmNotification(mode: mode, title: mode.message, soundFileName: soundName, startDate: startDate, endDate: endDate)
        )
    }
}

//MARK:- Time Cell Delegate
extension SettingsViewController: TimeCellDelegate {
    func timeCell(_ timeCell: TimeCell, didChangeTimeValues startDate: Date, endDate: Date) {
        Globals.alarms[mode]?.alarmTime = AlarmTime(startDate: startDate, endDate: endDate)
      //  schdeuleCurrentNotification(mode)
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
