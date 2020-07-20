//
//MARK:  SectionHeaderView.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
        
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        separator.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(separator)
    }
}
