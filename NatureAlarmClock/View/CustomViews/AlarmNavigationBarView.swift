//
//MARK:  AlarmNavigationBarView.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class AlarmNavigationBarView: UIView {
    static let nibName = "AlarmNavigationBarView"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    convenience init(title: String?, image: UIImage?, tintColor: UIColor = .systemGreen) {
        self.init()
        self.title = title
        titleLabel.text = title
        imageView.image = image
        imageView.tintColor = tintColor
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
