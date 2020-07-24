//
//MARK:  Sound.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

struct Sound {
    var soundName: String
    var fileNamePlusExtension: String
    var imageName: String?
    
    ///Custom thumbnail image name can be provided. If not, `thumbnailImage` property is computed using the object's `fileName`
    init(name: String, fileWIthExt: String, imageName: String? = nil) {
        self.soundName = name
        self.fileNamePlusExtension = fileWIthExt
        self.imageName = imageName
    }
}

extension Sound {
    ///The name of file without extension. E.g. if the sound file name is "forest.mp3", returns "forest"
    var fileName: String {
        return URL(string: fileNamePlusExtension)!.deletingPathExtension().lastPathComponent
    }
    
    ///The type of audio file. E.g. if the sound file name is "forest.mp3", returns "mp3"
    var fileType: String {
        return URL(string: fileNamePlusExtension)!.pathExtension
    }
    
    var url: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileType)
    }
    
    var thumbnailImage: UIImage? {
        if let name = imageName {
            return UIImage(named: name)
        }
        return UIImage(named: fileName)
    }
}
