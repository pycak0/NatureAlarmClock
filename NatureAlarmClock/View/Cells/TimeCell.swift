//
//  TimeCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol TimeCell {
    static var reuseIdentifier: String { get }
    var mode: AlarmMode! { get set }
    var hapticsGenerator: UIImpactFeedbackGenerator { get }
    var isDoneButtonPressed: Bool { get set }
    
    func configureCell(with time: AlarmTime, mode: AlarmMode)
    func doneButtonPressed()
    func configureTimePicker()
    func configureViews()
}
