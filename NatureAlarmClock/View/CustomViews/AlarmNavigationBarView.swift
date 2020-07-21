//
//MARK:  AlarmNavigationBarView.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol AlarmNavigationBarViewDelegate: class {
    func backButtonPressed()
}

class AlarmNavigationBarView: UIView {
    static let nibName = "AlarmNavigationBarView"
    
    weak var delegate: AlarmNavigationBarViewDelegate?
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    convenience init(title: String?, image: UIImage?, tintColor: UIColor) {
        self.init()
        self.title = title
        titleLabel.text = title
        titleLabel.textColor = tintColor
        imageView.image = image
        imageView.tintColor = tintColor
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        delegate?.backButtonPressed()
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}

private extension AlarmNavigationBarView {
    
    //MARK:- Xib Setup
    func xibSetup() {
        Bundle.main.loadNibNamed(AlarmNavigationBarView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
