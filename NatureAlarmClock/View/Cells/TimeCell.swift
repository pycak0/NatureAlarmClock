//
//MARK:  TimeCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol TimeCellDelegate: class {
    func timeCell(_ timeCell: TimeCell, didChangeTimeValues startTime: String, endTime: String)
}

class TimeCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeCell"
    
    weak var delegate: TimeCellDelegate?
    
    @IBOutlet private weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    
    let endPicker = UIDatePicker()
    let startPicker = UIDatePicker()
    var mode: AlarmMode!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    func configure(with time: AlarmTime, mode: AlarmMode) {
        startTimeField.text = time.start.string
        endTimeField.text = time.end.string
        startTimeField.backgroundColor = mode.color
        endTimeField.backgroundColor = mode.color
        self.mode = mode
        
        startPicker.date = Date().withGivenTime(hours: time.start.hour, minutes: time.start.minute)
        endPicker.date = Date().withGivenTime(hours: time.end.hour, minutes: time.end.minute)
        
        configurePicker()
    }
    
    //MARK:- Done Button Pressed
    @objc func doneButtonPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let startString = dateFormatter.string(from: startPicker.date)
        var endString = dateFormatter.string(from: endPicker.date)
        
        if startString >= endString {
            let newDate = startPicker.date.addingTimeInterval(10 * TimeInterval.secondsIn(.minute))
            endPicker.date = newDate
            endString = dateFormatter.string(from: newDate)
        }
        
        startTimeField.text = startString
        endTimeField.text = endString
        contentView.endEditing(true)
    }
    
    func configurePicker() {
        endPicker.datePickerMode = .time
        endPicker.locale = Locale(identifier: "ru_RU")
        startPicker.datePickerMode = .time
        startPicker.locale = Locale(identifier: "ru_RU")
                
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonPressed))
        done.tintColor = mode.color
        toolbar.setItems([done], animated: false)
        
        startTimeField.inputAccessoryView = toolbar
        startTimeField.inputView = startPicker
        endTimeField.inputAccessoryView = toolbar
        endTimeField.inputView = endPicker
    }
    
    func configureViews() {
        let cornerRadius = startTimeField.frame.height / 2
        startTimeField.layer.cornerRadius = cornerRadius
        endTimeField.layer.cornerRadius = cornerRadius
    }
    
}
