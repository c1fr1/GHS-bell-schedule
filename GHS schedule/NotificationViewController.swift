//
//  NotificationViewController.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/27/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import UserNotifications

/*var p1Duration:TimeInterval?
var p2Duration:TimeInterval?
var p3Duration:TimeInterval?
var p4Duration:TimeInterval?
var p5Duration:TimeInterval?
var p6Duration:TimeInterval?
var p7Duration:TimeInterval?
var p8Duration:TimeInterval?
var flexDuration:TimeInterval?
var lunchDuration:TimeInterval?*/

var beforeStart:Bool = false

class NotificationViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var p1switch: UISwitch!
    @IBOutlet weak var p2switch: UISwitch!
    @IBOutlet weak var p3switch: UISwitch!
    @IBOutlet weak var p4switch: UISwitch!
    @IBOutlet weak var p5switch: UISwitch!
    @IBOutlet weak var p6switch: UISwitch!
    @IBOutlet weak var p7switch: UISwitch!
    @IBOutlet weak var p8switch: UISwitch!
	@IBOutlet weak var flexswitch: UISwitch!
	@IBOutlet weak var lunchswitch: UISwitch!
	
	@IBOutlet weak var p1Field: UITextField!
    @IBOutlet weak var p2Field: UITextField!
    @IBOutlet weak var p3Field: UITextField!
    @IBOutlet weak var p4Field: UITextField!
    @IBOutlet weak var p5Field: UITextField!
    @IBOutlet weak var p6Field: UITextField!
    @IBOutlet weak var p7Field: UITextField!
    @IBOutlet weak var p8Field: UITextField!
	@IBOutlet weak var flexField: UITextField!
	@IBOutlet weak var lunchField: UITextField!
	var savingTimer:Timer!
    @IBAction func tap(_ sender: Any) {
        if p1Field.isFirstResponder {
            cleanup(field: p1Field)
        }else if p2Field.isFirstResponder {
            cleanup(field: p2Field)
        }else if p3Field.isFirstResponder {
            cleanup(field: p3Field)
        }else if p4Field.isFirstResponder {
            cleanup(field: p4Field)
        }else if p5Field.isFirstResponder {
            cleanup(field: p5Field)
        }else if p6Field.isFirstResponder {
            cleanup(field: p6Field)
        }else if p7Field.isFirstResponder {
            cleanup(field: p7Field)
        }else if p8Field.isFirstResponder {
            cleanup(field: p8Field)
		}else if flexField.isFirstResponder {
			cleanup(field: flexField)
		}else if lunchField.isFirstResponder {
			cleanup(field: lunchField)
		}
        view.endEditing(true)
    }
    @discardableResult func cleanup(field:UITextField) -> TimeInterval? {
        var time:Double?
        if field.text != nil {
            time = getInterval(from: field.text!)
        }
        if time != nil {
            let mins = Int(floor(time!/60))
            let secs = Int(time!) - mins*60
            var minsString = String(mins)
            while minsString.count < 2 {
                minsString = "0\(minsString)"
            }
            var secString = String(secs)
            while secString.count < 2 {
                secString = "0\(secString)"
            }
            field.text = "\(minsString):\(secString)"
            return Double(mins*60 + secs)
        }else {
            field.text = "10:00"
            return 10*60
        }
    }
    @IBAction func close(_ sender: Any) {
	UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())()
        dismiss(animated: true) {
            self.updateDurations()
            saveAndSchedule()
        }
        
    }
    func getInterval(from string:String) -> TimeInterval? {
        var startString:String = ""
        var secString:String?
        for char in string {
            if char != ":" {
                if secString == nil {
                    startString += String(char)
                }else {
                    if nil != Int(String(char)) {
                        secString! += String(char)
                    }
                }
            }else {
                secString = ""
                //TimeInterval.
            }
        }
        let min = Int(startString)
        var sec:Int?
        if secString != nil {
            sec = Int(secString!)
        }
        var retval:TimeInterval?
        if min != nil {
            retval = Double(min!)*60
            if sec != nil {
                retval! += Double(sec!)
            }
        }else {
            if sec != nil {
                retval! += Double(sec!)
            }
        }
        return retval
    }
    func updateDurations() {
		var p1Duration:TimeInterval?
		var p2Duration:TimeInterval?
		var p3Duration:TimeInterval?
		var p4Duration:TimeInterval?
		var p5Duration:TimeInterval?
		var p6Duration:TimeInterval?
		var p7Duration:TimeInterval?
		var p8Duration:TimeInterval?
		var flexDuration:TimeInterval?
		var lunchDuration:TimeInterval?
        if p1switch.isOn {
            p1Duration = cleanup(field: p1Field)
            if p1Duration == nil {
                p1Duration = 10*60
            }
        }else {
            p1Duration = nil
        }
        if p2switch.isOn {
            p2Duration = cleanup(field: p2Field)
            if p2Duration == nil {
                p2Duration = 10*60
            }
        }else {
            p2Duration = nil
        }
        if p3switch.isOn {
            p3Duration = cleanup(field: p3Field)
            if p3Duration == nil {
                p3Duration = 10*60
            }
        }else {
            p3Duration = nil
        }
        if p4switch.isOn {
            p4Duration = cleanup(field: p4Field)
            if p4Duration == nil {
                p4Duration = 10*60
            }
        }else {
            p4Duration = nil
        }
        if p5switch.isOn {
            p5Duration = cleanup(field: p5Field)
            if p5Duration == nil {
                p5Duration = 10*60
            }
        }else {
            p5Duration = nil
        }
        if p6switch.isOn {
            p6Duration = cleanup(field: p6Field)
            if p6Duration == nil {
                p6Duration = 10*60
            }
        }else {
            p6Duration = nil
        }
        if p7switch.isOn {
            p7Duration = cleanup(field: p7Field)
            if p7Duration == nil {
                p7Duration = 10*60
            }
        }else {
            p7Duration = nil
        }
        if p8switch.isOn {
            p8Duration = cleanup(field: p8Field)
            if p8Duration == nil {
                p8Duration = 10*60
            }
        }else {
            p8Duration = nil
        }
		if flexswitch.isOn {
			flexDuration = cleanup(field: flexField)
			if flexDuration == nil {
				flexDuration = 10*60
			}
		}else {
			flexDuration = nil
		}
		if lunchswitch.isOn {
			lunchDuration = cleanup(field: lunchField)
			if lunchDuration == nil {
				lunchDuration = 10*60
			}
		}else {
			lunchDuration = nil
		}
		if beforeStart {
			p1BeforeClassDuration = p1Duration
			p2BeforeClassDuration = p2Duration
			p3BeforeClassDuration = p3Duration
			p4BeforeClassDuration = p4Duration
			p5BeforeClassDuration = p5Duration
			p6BeforeClassDuration = p6Duration
			p7BeforeClassDuration = p7Duration
			p8BeforeClassDuration = p8Duration
			flexBeforeClassDuration = flexDuration
			lunchBeforeClassDuration = lunchDuration
		}else {
			p1EndClassDuration = p1Duration
			p2EndClassDuration = p2Duration
			p3EndClassDuration = p3Duration
			p4EndClassDuration = p4Duration
			p5EndClassDuration = p5Duration
			p6EndClassDuration = p6Duration
			p7EndClassDuration = p7Duration
			p8EndClassDuration = p8Duration
			flexEndClassDuration = flexDuration
			lunchEndClassDuration = lunchDuration
		}
    }
    override func viewDidLoad() {
        p1Field.delegate = self
        p2Field.delegate = self
        p3Field.delegate = self
        p4Field.delegate = self
        p5Field.delegate = self
        p6Field.delegate = self
        p7Field.delegate = self
        p8Field.delegate = self
		flexField.delegate = self
		lunchField.delegate = self
		
		var p1Duration:TimeInterval?
		var p2Duration:TimeInterval?
		var p3Duration:TimeInterval?
		var p4Duration:TimeInterval?
		var p5Duration:TimeInterval?
		var p6Duration:TimeInterval?
		var p7Duration:TimeInterval?
		var p8Duration:TimeInterval?
		var flexDuration:TimeInterval?
		var lunchDuration:TimeInterval?
		
		if beforeStart {
			p1Duration = p1BeforeClassDuration
			p2Duration = p2BeforeClassDuration
			p3Duration = p3BeforeClassDuration
			p4Duration = p4BeforeClassDuration
			p5Duration = p5BeforeClassDuration
			p6Duration = p6BeforeClassDuration
			p7Duration = p7BeforeClassDuration
			p8Duration = p8BeforeClassDuration
			flexDuration = flexBeforeClassDuration
			lunchDuration = lunchBeforeClassDuration
		}else {
			p1Duration = p1EndClassDuration
			p2Duration = p2EndClassDuration
			p3Duration = p3EndClassDuration
			p4Duration = p4EndClassDuration
			p5Duration = p5EndClassDuration
			p6Duration = p6EndClassDuration
			p7Duration = p7EndClassDuration
			p8Duration = p8EndClassDuration
			flexDuration = flexEndClassDuration
			lunchDuration = lunchEndClassDuration
		}
		
        var mins:Int?
        var secs:Int?
        if p1Duration != nil {
            mins = Int(floor(p1Duration!/60))
            secs = Int(p1Duration!) - mins!*60
            p1Field.text = "\(mins!):\(secs!)"
            p1switch.isOn = true
            cleanup(field: p1Field)
        }
        if p2Duration != nil {
            mins = Int(floor(p2Duration!/60))
            secs = Int(p2Duration!) - mins!*60
            p2Field.text = "\(mins!):\(secs!)"
            p2switch.isOn = true
            cleanup(field: p2Field)
        }
        if p3Duration != nil {
            mins = Int(floor(p3Duration!/60))
            secs = Int(p3Duration!) - mins!*60
            p3Field.text = "\(mins!):\(secs!)"
            p3switch.isOn = true
            cleanup(field: p3Field)
        }
        if p4Duration != nil {
            mins = Int(floor(p4Duration!/60))
            secs = Int(p4Duration!) - mins!*60
            p4Field.text = "\(mins!):\(secs!)"
            p4switch.isOn = true
            cleanup(field: p4Field)
        }
        if p5Duration != nil {
            mins = Int(floor(p5Duration!/60))
            secs = Int(p5Duration!) - mins!*60
            p5Field.text = "\(mins!):\(secs!)"
            p5switch.isOn = true
            cleanup(field: p5Field)
        }
        if p6Duration != nil {
            mins = Int(floor(p6Duration!/60))
            secs = Int(p6Duration!) - mins!*60
            p6Field.text = "\(mins!):\(secs!)"
            p6switch.isOn = true
            cleanup(field: p6Field)
        }
        if p7Duration != nil {
            mins = Int(floor(p7Duration!/60))
            secs = Int(p7Duration!) - mins!*60
            p7Field.text = "\(mins!):\(secs!)"
            p7switch.isOn = true
            cleanup(field: p7Field)
        }
        if p8Duration != nil {
            mins = Int(floor(p8Duration!/60))
            secs = Int(p8Duration!) - mins!*60
            p8Field.text = "\(mins!):\(secs!)"
            p8switch.isOn = true
            cleanup(field: p8Field)
        }
		if flexDuration != nil {
			mins = Int(floor(flexDuration!/60))
			secs = Int(flexDuration!) - mins!*60
			flexField.text = "\(mins!):\(secs!)"
			flexswitch.isOn = true
			cleanup(field: flexField)
		}
		if lunchDuration != nil {
			mins = Int(floor(lunchDuration!/60))
			secs = Int(lunchDuration!) - mins!*60
			lunchField.text = "\(mins!):\(secs!)"
			lunchswitch.isOn = true
			cleanup(field: lunchField)
		}
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cCount = textField.text!.count
        if string == "" {
            if cCount == 3 {
                textField.text?.removeLast()
            }
            return true
        }
        if cCount < 1 {
            if Int(string) != nil {
                return true
            }else {
                return false
            }
        }else if cCount == 1 {
            if Int(string) != nil {
                textField.text = "\(textField.text!)\(string):"
            }
            return false
        }else if cCount > 2 && cCount < 5 {
            if Int(string) != nil {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
}
func scheduleForPeriod(period: String, date:(Int, Int, Int), duration:TimeInterval?, last:Bool, start:Bool) -> Bool {
	if duration != nil {
		if last {
			if scheduleNotification(period: period, interval: duration!, forDate: date, last: true, start: start) {
				return true
			}
		}
		if scheduleNotification(period: period, interval: duration!, forDate: date, start: start) {
			return true
		}
	}
	return false
}
@discardableResult func scheduleNotifications(forDate:(Int, Int, Int), remaining:Int) -> Int {
    var retval = 0
	var durations:[TimeInterval?] = [p1BeforeClassDuration, p2BeforeClassDuration, p3BeforeClassDuration, p4BeforeClassDuration, p5BeforeClassDuration, p6BeforeClassDuration, p7BeforeClassDuration, p8BeforeClassDuration]
	var dureetions:[TimeInterval?] = [p1EndClassDuration, p2EndClassDuration, p3EndClassDuration, p4EndClassDuration, p5EndClassDuration, p6EndClassDuration, p7EndClassDuration, p8EndClassDuration]
	var duration = durations[0]
	for i in 1...8 {
		duration = durations[i - 1]
		if scheduleForPeriod(period: "P\(i)", date: forDate, duration: duration, last: remaining - retval == 0, start: true) {
			retval += 1
		}
		if remaining - retval == -1 {
			return retval
		}
		duration = dureetions[i - 1]
		if scheduleForPeriod(period: "P\(i)", date: forDate, duration: duration, last: remaining - retval == 0, start: false) {
			retval += 1
		}
		if remaining - retval == -1 {
			return retval
		}
	}
	duration = flexBeforeClassDuration
	if scheduleForPeriod(period: "FLEX", date: forDate, duration: duration, last: remaining - retval == 0, start: true) {
		retval += 1
	}
	if remaining - retval == -1 {
		return retval
	}
	duration = flexEndClassDuration
	if scheduleForPeriod(period: "FLEX", date: forDate, duration: duration, last: remaining - retval == 0, start: false) {
		retval += 1
	}
	if remaining - retval == -1 {
		return retval
	}
	duration = lunchBeforeClassDuration
	if scheduleForPeriod(period: "LUNCH", date: forDate, duration: duration, last: remaining - retval == 0, start: true) {
		retval += 1
	}
	if remaining - retval == -1 {
		return retval
	}
	duration = lunchEndClassDuration
	if scheduleForPeriod(period: "LUNCH", date: forDate, duration: duration, last: remaining - retval == 0, start: false) {
		retval += 1
	}
	if remaining - retval == -1 {
		return retval
	}
    return retval
}
func saveAndSchedule() {
    var count = 0
    var index = 0
    while orderedSchedule!.count > index {
        if getDate(from: getDateInts()) >= orderedSchedule![index].0 {
            index += 1
		}else {
			break
		}
    }
    index -= 1
    while count < 64 {
        if orderedSchedule!.count <= index {
            break
        }
        if orderedSchedule!.count > 0 {
            let ints = getIntsFor(date: orderedSchedule![index].0)
            count += scheduleNotifications(forDate: ints, remaining: 63 - count)
            index += 1
        }else {
            break
        }
    }
}
