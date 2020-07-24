//
//  SplashViewController.swift
//  NatureAlarmClock
//
//  Created by Владислав on 24.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setRootVC()
        }
    }
    
    func setRootVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        let window = UIApplication.shared.windows.first!
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
