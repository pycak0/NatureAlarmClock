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
    func clearNavigationBar() {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.isOpaque = false
        navBar.layoutIfNeeded()
    }
    
    func setupNavBarTitleView(text: String? = nil, tintColor: UIColor = .systemGreen, customImage: UIImage? = nil) {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        clearNavigationBar()
        
        let image = UIImage(named: "alarm")
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor

        let barWidth = navBar.frame.size.width
        let barHeight = navBar.frame.size.height

        let bannerX = barWidth / 2 - (image?.size.width)! / 2
        let bannerY = barHeight / 2 - (image?.size.height)! / 2

        imageView.frame = CGRect(x: 0, y: 20, width: 30, height: 22)
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
    }
}
