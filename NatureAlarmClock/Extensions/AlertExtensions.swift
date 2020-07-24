//
//  AlertExtensions.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK:- Simple Alert
    /**A simple alert that gives some additional info,
     has only one  button which dismisses the alert controller by default.
     Use it for displaying supplementary messages e.g. successful url request.
     Default button title is 'OK', also any action can be assigned to the button with the closure.
     */
    func showSimpleAlert(title: String = "Успешно!", message: String = "", okButtonTitle: String = "OK", okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.view.tintColor = .label
        let okBtn = UIAlertAction(title: okButtonTitle, style: .default, handler: okHandler)
        alert.addAction(okBtn)
        
        present(alert, animated: true, completion: nil)
    }
}
