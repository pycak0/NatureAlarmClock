//
//MARK:  AlarmMode.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

enum AlarmMode: String {
    case sleep, wakeUp
    
    var image: UIImage? {
        let imageName = self == .sleep ? "sleepImageBig.png" : "wakeupImageBig.png"
        return UIImage(named: imageName)
    }
    
    var message: String {
        return self == .sleep ? "Я засыпаю" : "Я просыпаюсь"
    }
    
    var color: UIColor {
        return self == .sleep ? .blueSleep : .pinkWakeup
    }
}
