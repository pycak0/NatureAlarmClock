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
        sleep(1)
        setRootVC()
    }
    
    func setRootVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        let window = UIApplication.shared.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
