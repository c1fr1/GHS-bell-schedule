//
//  MMSSPickerViewController.swift
//  GHS schedule
//
//  Created by Jeffrey R Lewis on 1/2/18.
//  Copyright © 2018 4inunison. All rights reserved.
//

import UIKit

class MMSSPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var labelView : UILabel!
    @IBOutlet var pickerView : UIPickerView!
    @IBOutlet var doneButton : UIButton!

    // var notificationController : NotificationViewController?
    var notificationController : NotificationViewController2?
    var info : PeriodInfo?
    // var periodName : String = "Period ?"
    var periodName : String {
        return info?.name.value ?? "Period"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelView.text = "Reminder before \(periodName) ends"
        let dur = duration
        let mins = Int(floor(dur / 60))
        let secs = Int(dur) - mins * 60
        pickerView.selectRow(mins, inComponent: 0, animated: animated)
        pickerView.selectRow(secs / 5, inComponent: 2, animated: animated)
    }
    
    var isBeforeStart : Bool {
        if let controller = notificationController
        {
            return controller.isBeforeStart
        }
        return false
    }

    var duration : TimeInterval
    {
        get {
            return (isBeforeStart ? info?.beforeDuration.value : info?.endDuration.value) ?? PeriodInfo.defaultDuration
        }
        set(d) {
            if isBeforeStart {
                info?.beforeDuration.value = d
            } else {
                info?.endDuration.value = d
            }
        }
    }
    
    var minutes : Int {
        return pickerView.selectedRow(inComponent: 0)
    }
    
    var seconds : Int {
        return pickerView.selectedRow(inComponent: 2) * 5
    }
    
    @IBAction func done(_ : AnyObject)
    {
        let mins = minutes
        let secs = seconds
        duration = TimeInterval(mins * 60 + secs)
        if duration != 0 {
            notificationController?.tableController?.tableView.reloadData()
            dismiss(animated: true)
        }
    }

    // MARK: UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 100
        } else if component == 2 {
            return 12
        }
        return 1
    }

    // MARK: UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 || component == 2 {
            return 48
            /*
            let str = "88"
            let font = UIFont.systemFont(ofSize: 17)
            let size = str.size(withAttributes: [.font : font])
            return size.width + 16 */
        }
        return 48
        /*
        let str = "min"
        let font = UIFont.systemFont(ofSize: 17)
        let size = str.size(withAttributes: [.font : font])
        return size.width + 16 */
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row)
        } else if component == 2 {
            return String(row * 5)
        } else if component == 1 {
            return "min"
        }
        return "sec"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        doneButton.isEnabled = !(minutes == 0 && seconds == 0)
    }
}
