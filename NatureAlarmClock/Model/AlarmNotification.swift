//
//  AlarmNotification.swift
//  NatureAlarmClock
//
//  Created by Владислав on 21.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct AlarmNotification {
    var mode: AlarmMode
    var title: String
    var soundFileName: String
    var startDate: DateComponents
    var endDate: DateComponents
}
