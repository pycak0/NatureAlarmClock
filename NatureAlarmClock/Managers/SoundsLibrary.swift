//
//  SoundsLibrary.swift
//  NatureAlarmClock
//
//  Created by Владислав on 24.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SoundsLibrary {
    //singleton
    private init() {}
    
    static func getMainSounds(_ mode: AlarmMode) -> [Sound] {
        switch mode {
        case .sleep:
            return mainSleepSounds
        case .wakeUp:
            return mainWakeSounds
        }
    }
    
    static func getSecondarySounds(_ mode: AlarmMode) -> [Sound] {
        switch mode {
        case .sleep:
            return secondarySleepSounds
        case .wakeUp:
            return secondaryWakeSounds
        }
    }
    
    //Sounds now are the same
    private static let mainWakeSounds = mainSleepSounds
    private static let mainSleepSounds: [Sound] = [
        Sound(name: "В самолёте", fileWIthExt: "plane.m4a"),
        Sound(name: "Ветер", fileWIthExt: "wind.m4a"),
        Sound(name: "Водопад", fileWIthExt: "waterfall.m4a"),
        Sound(name: "Город", fileWIthExt: "city.m4r"),
        Sound(name: "Гроза", fileWIthExt: "thunderstorm.m4r"),
        Sound(name: "Деньги", fileWIthExt: "money.m4r"),
        Sound(name: "Йога", fileWIthExt: "yoga.m4r"),
        Sound(name: "Камин", fileWIthExt: "fireplace.m4r"),
        Sound(name: "Китайская тема", fileWIthExt: "chinese.m4r"),
        Sound(name: "Книга", fileWIthExt: "book.m4r"),
        Sound(name: "Мурчание кота", fileWIthExt: "cat.m4r"),
        Sound(name: "Пение птиц", fileWIthExt: "birds.m4r"),
        Sound(name: "Пляж", fileWIthExt: "beach.m4r"),
        Sound(name: "Поезд", fileWIthExt: "train.m4r"),
        Sound(name: "Прилив моря", fileWIthExt: "sea.m4r"),
        Sound(name: "Ручей в лесу", fileWIthExt: "stream.m4r"),
        Sound(name: "Тибетские чаши", fileWIthExt: "tibet.m4r"),
        Sound(name: "Тропический лес", fileWIthExt: "tropicalForest.m4r"),
        Sound(name: "Флейта", fileWIthExt: "flute.m4r"),
        Sound(name: "Фортепиано", fileWIthExt: "piano.m4a")
    ]
    private static let secondaryWakeSounds = secondarySleepSounds
    private static let secondarySleepSounds: [Sound] = [
        
    ]
}
