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
    
    var sections: [Section: [Any]] = [
        .time : [
            AlarmTime(start: "7:30", end: "8:00")
        ],
        .mainSound : [
            Sound(name: "Рассвет", file: "", withExtension: ""),
            Sound(name: "Прибой", file: "", withExtension: ""),
            Sound(name: "Лес", file: "forestSound", withExtension: "m4r"),
            Sound(name: "Море", file: "", withExtension: ""),
            Sound(name: "Поле", file: "", withExtension: "")
        ],
        .additionalSound : [
            Sound(name: "Чайка", file: "", withExtension: ""),
            Sound(name: "Дятел", file: "", withExtension: ""),
            Sound(name: "Петух", file: "", withExtension: "")
        ]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(delegate: self, text: mode.message, tintColor: mode.color)
        configureViews()
    }
    
    func configureViews() {
        configureCollectionView()
        guard let startDate = SavedAlarms.general.startDate(mode),
            let endDate = SavedAlarms.general.endDate(mode)
        else { return }
        
        sections[.time] = [AlarmTime(startDate: startDate, endDate: endDate)]
    }
    
    func configureCollectionView() {
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
}

extension SettingsViewController: AlarmNavigationBarViewDelegate {
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}


extension SettingsViewController: TimeCellDelegate {
    func timeCell(_ timeCell: TimeCell, didChangeTimeValues startDate: Date, endDate: Date) {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        AlarmsManager.general.scheduleNotification(
            alarm: AlarmNotification(mode: mode, title: mode.message, soundFileName: "forestSound.m4r", startDate: dateComponents, endDate: endComponents)
        )
    }
    
}
