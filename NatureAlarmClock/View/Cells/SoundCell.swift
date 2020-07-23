//
//MARK:  SoundCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVKit

protocol SoundCellDelegate: class {
    func soundCell(_ soundCell: SoundCell, didReceiveAudioPlaybackError error: Error)
    func soundCell(_ soundCell: SoundCell, didPressPlayButton playButton: UIButton)
}

class SoundCell: UICollectionViewCell {
    static let reuseIdentifier = "SoundCell"
    
    weak var delegate: SoundCellDelegate?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet weak var soundNameLabel: UILabel!
    
    var onReuse: (() -> Void)?
    private var player: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pause()
        onReuse?()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        delegate?.soundCell(self, didPressPlayButton: sender)
    }
    
    func configure(with sound: Sound) {
        //playButton.isUserInteractionEnabled = false
        
        soundNameLabel.text = sound.soundName
        guard let url = sound.url else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
        }
        catch(let error) {
            delegate?.soundCell(self, didReceiveAudioPlaybackError: error)
        }
    }
    
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }
    
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch(let error) {
            delegate?.soundCell(self, didReceiveAudioPlaybackError: error)
        }
        guard player != nil else {
            return
        }
        
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        player?.play()
    }
    
    func pause() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        player?.pause()
    }
    
    func setSelected(_ mode: AlarmMode) {
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = mode.color.cgColor
        
        isSelected = true
    }
    
    func deselect() {
        contentView.layer.borderWidth = 0
        isSelected = false
    }
    
}
