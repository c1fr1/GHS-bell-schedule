//
//  NotificationViewController.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/27/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

var p1Duration:TimeInterval?
var p2Duration:TimeInterval?
var p3Duration:TimeInterval?
var p4Duration:TimeInterval?
var p5Duration:TimeInterval?
var p6Duration:TimeInterval?
var p7Duration:TimeInterval?
var p8Duration:TimeInterval?

class NotificationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var p1switch: UISwitch!
    @IBOutlet weak var p2switch: UISwitch!
    @IBOutlet weak var p3switch: UISwitch!
    @IBOutlet weak var p4switch: UISwitch!
    @IBOutlet weak var p5switch: UISwitch!
    @IBOutlet weak var p6switch: UISwitch!
    @IBOutlet weak var p7switch: UISwitch!
    @IBOutlet weak var p8switch: UISwitch!
    @IBOutlet weak var p1Field: UITextField!
    @IBOutlet weak var p2Field: UITextField!
    @IBOutlet weak var p3Field: UITextField!
    @IBOutlet weak var p4Field: UITextField!
    @IBOutlet weak var p5Field: UITextField!
    @IBOutlet weak var p6Field: UITextField!
    @IBOutlet weak var p7Field: UITextField!
    @IBOutlet weak var p8Field: UITextField!
    @IBAction func tap(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func close(_ sender: Any) {
        if p1switch.isOn {
            p1Duration =
        }
        dismiss(animated: true, completion: nil)
    }
    func getInterval(from string:String) -> TimeInterval {
        var startString:String = ""
        var retVal:TimeInterval = 0
        for char in string.characters {
            if char != ":" {
                startString += String(char)
            }else {
                TimeInterval.
            }
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
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == ":" || Int(string) != nil || string == "" {
            return true
        }
        return false
    }
}
