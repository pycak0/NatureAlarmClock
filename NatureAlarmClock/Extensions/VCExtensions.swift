//
//MARK:  VCExtensions.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// Extensions for the UIViewController

extension UIViewController {
    
    //MARK:- Clear Navigation Bar
    ///Clears navigation bar's background color and separator
    func clearNavigationBar(clearBorder: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        if clearBorder {
            navBar.shadowImage = UIImage()
        }
        navBar.isTranslucent = true
        navBar.isOpaque = false
        navBar.backIndicatorTransitionMaskImage = UIImage()
        navBar.backIndicatorImage = UIImage()
        navBar.layoutIfNeeded()
    }
    
    func setupNavBarTitleView(delegate: AlarmNavigationBarViewDelegate?, text: String? = nil, tintColor: UIColor = .systemGreen, customImage: UIImage? = nil) {
        clearNavigationBar(clearBorder: text == nil)
        
        let titleView = AlarmNavigationBarView(title: text, image: customImage ?? UIImage(named: "alarm"), tintColor: tintColor)
        titleView.delegate = delegate
        titleView.backButton.isHidden = titleView.delegate == nil
        view.addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titleView.heightAnchor.constraint(equalToConstant: navBarHeight(text != nil))
        ])
        
    }
    
    func navBarHeight(_ isTitleEnabled: Bool) -> CGFloat {
        return isTitleEnabled ? 140 : 105
//        return 120
//        switch UIScreen.main.nativeBounds.height {
//        case 2436, 2688, 1792:
//            return 100
//        // iPhone 5s-style
//        case 1136:
//            return 80
//        // Any other iPhone
//        default:
//            return 90
//        }
    }
}
