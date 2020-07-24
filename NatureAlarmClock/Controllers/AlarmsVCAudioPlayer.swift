//
//  AlarmsVCAudioPlayer.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import AVKit

extension AlarmsViewController {
    
    func startPlayer(_ mode: AlarmMode) {
        var soundUrl: URL
        if let mixedSoundUrl = Globals.alarm(mode).mixedSoundUrl {
            soundUrl = mixedSoundUrl
        } else if let mainSoundUrl = Globals.alarm(mode).mainSoundUrl {
            soundUrl = mainSoundUrl
        } else {
            showSimpleAlert(title: "Не удалось воспроизвести мелодию", message: "Попробуйте выбрать звук ещё раз и включить снова")
            return
        }
        
        do {
            self.player = try AVAudioPlayer(contentsOf: soundUrl)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error)
        }
        
        guard player != nil else {
            return
        }
        
        player?.numberOfLoops = -1
        player?.play()
       // sleepAlarmView.setSwitchButtonImage(UIImage(named: "Play"))
        
        print("Timer for \(Globals.alarm(mode).alarmTime.start.timeInterval) sec")
        timer = Timer.scheduledTimer(withTimeInterval: Globals.alarm(mode).alarmTime.start.timeInterval, repeats: false) { (t) in
            print("Timer fired")
            self.stopPlayer()
        }
    }
    
    func stopPlayer() {
   //     sleepAlarmView.setSwitchButtonImage(UIImage(named: "Pause"))
        player?.stop()
        Globals.alarm(.sleep).isSwitchedOn = false
        sleepAlarmView.isSwitchedOn = false
        timer?.invalidate()
    }
}
