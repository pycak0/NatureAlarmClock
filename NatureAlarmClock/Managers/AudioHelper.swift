//
//  AudioHelper.swift
//  NatureAlarmClock
//
//  Created by Владислав on 22.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import AVKit
import MobileCoreServices

enum ExportError: Error {
    case invalidUrl, failedToCreateTrack, failedToCreateSession, assetTrackError
    case exportSessionFailed, exportSessionCancelled, unknown
    case other(Error)
}

protocol AudioHelperDelegate: class {
    func audioHelper(didFinishExportSession exportSession: AVAssetExportSession, with error: ExportError?, or url: URL?)
}

class AudioHelper {
    private init() {}
    
    //MARK:- Sounds Directory
    static var soundsDirectory: URL {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Sounds")
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        } catch {
            print(error)
        }
        return url
    }
    
    //MARK:- Create Destination Url
    private static func createDestinationUrl(_ mainUrl: URL, _ secondUrl: URL) -> URL {
        let mainName = mainUrl.deletingPathExtension().lastPathComponent
        let secondName = secondUrl.deletingPathExtension().lastPathComponent
        let fullFileName = mainName + secondName + ".m4a"
        return soundsDirectory.appendingPathComponent(fullFileName)
    }

    //MARK:- Merge Audios
    static func mergeAudios(mainSound: Sound, secondSound: Sound, completion: @escaping ((URL?, ExportError?) -> Void)) {
        guard let mainUrl = mainSound.url, let secondUrl = secondSound.url else {
            completion(nil, .invalidUrl)
            return
        }
        
        let destinationUrl = createDestinationUrl(mainUrl, secondUrl)
        guard !FileManager.default.fileExists(atPath: destinationUrl.path) else {
            print("Returnning the existing audio at url \(destinationUrl)")
            completion(destinationUrl, nil)
            return
        }
        print("Preparing to merge two tracks to url: \(destinationUrl) ...")

        let mixComposition = AVMutableComposition()
        guard let mainTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid),
            let secondTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil, .failedToCreateTrack)
            return
        }
        var compositionMainAudioTrack: AVMutableCompositionTrack = mainTrack
        var compositionSecondaryAudioTrack: AVMutableCompositionTrack = secondTrack

        let mainAsset = AVAsset(url: mainUrl)
        let secondAsset = AVAsset(url: secondUrl)
        
        guard let mainAssetTrack = mainAsset.tracks(withMediaType: .audio).first,
            let secondAssetTrack = secondAsset.tracks(withMediaType: .audio).first else {
                completion(nil, .assetTrackError)
                return
        }
        
        let mainDuration = mainAssetTrack.timeRange.duration
        let secondDuration = secondAssetTrack.timeRange.duration
        
        //let res = CMTimeCompare(mainDuration, secondDuration)
        
        let mainTimeRange = CMTimeRangeMake(start: .zero, duration: mainDuration)
        let secondTimeRange = CMTimeRangeMake(start: .zero, duration: secondDuration)
        
        do {
            try compositionMainAudioTrack.insertTimeRange(mainTimeRange, of: mainAssetTrack, at: .zero)
            //try compositionSecondaryAudioTrack.insertTimeRange(mainTimeRange, of: secondAssetTrack, at: .zero)
            
            if CMTimeCompare(mainDuration, secondDuration) == -1 {
                // если главный звуе короче, чем дополнительный, то обрезаем дополнительный
                try compositionSecondaryAudioTrack.insertTimeRange(mainTimeRange, of: secondAssetTrack, at: CMTime.zero)

            } else if CMTimeCompare(mainDuration, secondDuration) == 1 {
                // если главный звуе короче, чем дополнительный, то зацикливаем
                var currentTime = CMTime.zero
                while true {
                    var audioDuration = secondAsset.duration
                    let totalDuration = CMTimeAdd(currentTime, audioDuration)
                    if CMTimeCompare(totalDuration, mainDuration) == 1 {
                        audioDuration = CMTimeSubtract(totalDuration, mainDuration)
                    }
                    try compositionSecondaryAudioTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: mainDuration), of: secondAssetTrack, at: currentTime)

                    currentTime = CMTimeAdd(currentTime, audioDuration)
                    if CMTimeCompare(currentTime, mainDuration) == 1 || CMTimeCompare(currentTime, mainDuration) == 0 {
                        break
                    }
                }
            }
        } catch {
            completion(nil, .other(error))
            return
        }
        
        //MARK:- Export Session
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetAppleM4A) else {
            completion(nil, .failedToCreateSession)
            return
        }
        exportSession.outputFileType = .m4a
        exportSession.outputURL = destinationUrl
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                case .completed:
                    completion(destinationUrl, nil)
                case .failed:
                    completion(nil, .exportSessionFailed)
                case .cancelled:
                    completion(nil, .exportSessionCancelled)
                default:
                    completion(nil, .unknown)
                }
            }
            
        }
        
    }
}
