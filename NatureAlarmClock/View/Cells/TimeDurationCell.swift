//
//MARK:  TimeDurationCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 23.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol TimeDurationCellDelegate: class {
    func timeDurationCell(_ timeDurationCell: TimeDurationCell, didChangeDurationTo hours: Int, _ minutes: Int)
}

class TimeDurationCell: UICollectionViewCell, TimeCell {
    static let reuseIdentifier = "TimeDurationCell"
    
    weak var delegate: TimeDurationCellDelegate?
    
    @IBOutlet weak var timeField: UITextField!
    
    //let timePicker = UIPickerView()
    let timePicker = UIDatePicker()
    var mode: AlarmMode!
    var isDoneButtonPressed = false
    
    var hapticsGenerator: UIImpactFeedbackGenerator {
        UIImpactFeedbackGenerator()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    //MARK:- Done Button Pressed
    @objc func doneButtonPressed() {
        isDoneButtonPressed = true
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        let hours = components.hour!
        let minutes = components.minute!
        timeField.text = hours > 0 ? String(format: "%d ч %02d мин", hours, minutes) : "\(minutes) мин"
        
        delegate?.timeDurationCell(self, didChangeDurationTo: hours, minutes)
        
        contentView.endEditing(true)
        isDoneButtonPressed = false
    }
    
    //MARK:- Configure Cell
    func configureCell(with time: AlarmTime, mode: AlarmMode) {
        self.mode = mode
        timeField.text = time.start.fullString
        timeField.backgroundColor = mode.color
        
        timePicker.date = time.start.date
        configureTimePicker()
    }
    
    //MARK:- Configure Time Picker
    func configureTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date().withGivenTime(hours: 0, minutes: 1)
        timePicker.locale = Locale(identifier: "ru_RU")
        
        timeField.inputView = timePicker
        timeField.inputAccessoryView = UIToolbar(withSingleItemNamed: "Готово", target: self, action: #selector(doneButtonPressed), tintColor: mode.color)
        timeField.delegate = self
        
    }
    
    //MARK:- Configure Views
    func configureViews() {
        let cornerRadius = timeField.frame.height / 2
        timeField.layer.cornerRadius = cornerRadius
    }
}

extension TimeDurationCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hapticsGenerator.impactOccurred()
    }
}
