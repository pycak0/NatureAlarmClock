//
//  SoundCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVKit

protocol SoundCellDelegate: class {
    func soundCell(_ soundCell: SoundCell, didReceiveAudioPlaybackError error: Error)
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
    
    func configure(with sound: Sound) {
        playButton.isUserInteractionEnabled = false
        
        soundNameLabel.text = sound.soundName
        guard let url = sound.url else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
        }
        catch(let error) {
            delegate?.soundCell(self, didReceiveAudioPlaybackError: error)
        }
    }
    
    lazy var isPlaying: Bool = {
        player?.isPlaying ?? false
    }()
    
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch(let error) {
            delegate?.soundCell(self, didReceiveAudioPlaybackError: error)
        }
        playButton.setImage(UIImage(named: "Pause"), for: .normal)
        player?.play()
    }
    
    func pause() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        player?.pause()
    }
}
