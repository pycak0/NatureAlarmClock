//
//  UIKitExtensions.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIToolbar {
    convenience init(withSingleItemNamed title: String, target: Any?, action: Selector?, tintColor: UIColor, style: UIBarButtonItem.Style = .done) {
        self.init()
        self.sizeToFit()
        let done = UIBarButtonItem(title: title, style: style, target: target, action: action)
        self.setItems([done], animated: false)
    }
}
