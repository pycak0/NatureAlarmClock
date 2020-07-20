//
//MARK:  Sound.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct Sound {
    var soundName: String
    var fileName: String
    var fileType: String
    
    init(name: String, file: String, withExtension ext: String) {
        self.soundName = name
        self.fileName = file
        self.fileType = ext
    }
    
    var url: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileType)
    }
}
