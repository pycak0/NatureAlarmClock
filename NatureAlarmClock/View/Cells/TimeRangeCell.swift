//
//MARK:  TimeRangeCell.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol TimeRangeCellDelegate: class {
    func timeCell(_ timeCell: TimeRangeCell, didChangeTimeValues startDate: Date, endDate: Date)
}

class TimeRangeCell: UICollectionViewCell, TimeCell {
    static let reuseIdentifier = "TimeRangeCell"
    
    weak var delegate: TimeRangeCellDelegate?
    
    @IBOutlet private weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    
    let endPicker = UIDatePicker()
    let startPicker = UIDatePicker()
    var mode: AlarmMode!
    var isDoneButtonPressed = false
    
    var hapticsGenerator: UIImpactFeedbackGenerator {
        UIImpactFeedbackGenerator()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    //MARK:- Configure Cell
    func configureCell(with time: AlarmTime, mode: AlarmMode) {
        self.mode = mode
        startTimeField.text = time.start.shortString
        endTimeField.text = time.end.shortString
        startTimeField.backgroundColor = mode.color
        endTimeField.backgroundColor = mode.color

        startPicker.date = time.start.date
        endPicker.date = time.end.date
        
        configureTimePicker()
    }
        
    //MARK:- Done Button Pressed
    @objc func doneButtonPressed() {
        isDoneButtonPressed = true
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let startString = dateFormatter.string(from: startPicker.date)
        var endString = dateFormatter.string(from: endPicker.date)
        startTimeField.text = startString
        endTimeField.text = endString
        //print(endTimeField.text, "haha")
        
        if startString >= endString {
            let newDate = startPicker.date.addingTimeInterval(5 * .secondsIn(.minute))
            endPicker.setDate(newDate, animated: true)

            UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                self.endTimeField.alpha = 0
            }, completion: { _ in
                self.endTimeField.alpha = 1
                
                endString = dateFormatter.string(from: newDate)
                self.startTimeField.text = startString
                self.endTimeField.text = endString
              //  print(self.endTimeField.text)
            })
        }
        
        delegate?.timeCell(self, didChangeTimeValues: startPicker.date, endDate: endPicker.date)
        
        contentView.endEditing(true)
        isDoneButtonPressed = false
    }
    
    //MARK:- Configure Time Picker
    func configureTimePicker() {
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
        
        startTimeField.delegate = self
        endTimeField.delegate = self
    }
    
    //MARK:- Configure Views
    func configureViews() {
        let cornerRadius = startTimeField.frame.height / 2
        startTimeField.layer.cornerRadius = cornerRadius
        endTimeField.layer.cornerRadius = cornerRadius
    }
}


extension TimeRangeCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hapticsGenerator.impactOccurred()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("did end editing")
        guard !isDoneButtonPressed else {
            return
        }
        doneButtonPressed()
    }
}
