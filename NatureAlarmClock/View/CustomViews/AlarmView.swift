//
//MARK:  AlarmView.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol AlarmViewDelegate: class {
    func alarmView(_ alarmView: AlarmView, didPressSettingsButton settingsButton: UIButton)
    func alarmView(_ alarmView: AlarmView, didPressSwitchButton switchButton: UIButton)
}

class AlarmView: UIView {
    static let nibName = "AlarmView"
    
    weak var delegate: AlarmViewDelegate?
    
    //MARK:- Properties
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var switchButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var switchIndicatorView: UIView!
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    convenience init(mode: AlarmMode, time: String) {
        self.init()
        self.mode = mode
        self.time = time
    }
    
    @IBAction private func switchButtonPressed(_ sender: UIButton) {
        delegate?.alarmView(self, didPressSwitchButton: sender)
    }
    
    @IBAction private func settingsButtonPressed(_ sender: UIButton) {
        delegate?.alarmView(self, didPressSettingsButton: sender)
    }
    
    //MARK:- Public
    var mode: AlarmMode! {
        didSet {
            configureViews(mode)
        }
    }
    
    var time: String! {
        didSet {
            timeLabel.text = time
        }
    }
    
    var isSwitchedOn: Bool = false {
        didSet {
            let alpha: CGFloat = isSwitchedOn ? 0.01 : 0.5
            UIView.animate(withDuration: 0.2) {
                self.switchIndicatorView.alpha = alpha
            }
            switchButton.tintColor = isSwitchedOn ? .systemGreen : .systemRed
        }
    }
    
    func setSwitchButtonImage(_ image: UIImage?, tintColor: UIColor = .systemGreen) {
        switchButton.setImage(image, for: .normal)
        switchButton.tintColor = tintColor
    }
    
}

private extension AlarmView {
    
    //MARK:- Xib Setup
    func xibSetup() {
        Bundle.main.loadNibNamed(AlarmView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func configureViews(_ mode: AlarmMode) {
        imageView.image = mode.image
        messageLabel.text = mode.message
        timeLabel.backgroundColor = mode.color
        addTapGestureRecognizer()
        
        timeLabel.layer.cornerRadius = timeLabel.frame.height / 2
    }
    
    func addTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsButtonPressed(_:)))
        imageView.addGestureRecognizer(tapRecognizer)
        //timeLabel.addGestureRecognizer(tapRecognizer)
    }
}
