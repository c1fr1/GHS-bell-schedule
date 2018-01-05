//
//  ScheduleViewController.swift
//  GHS schedule
//
//  Created by Jeffrey R Lewis on 1/5/18.
//  Copyright © 2018 4inunison. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func close(_ : AnyObject) {
        dismiss(animated: true) {
            // self.updateDurations()
            // saveAndSchedule()
        }
    }
}
