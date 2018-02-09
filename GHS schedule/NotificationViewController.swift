//
//  NotificationViewController.swift
//  GHS schedule
//
//  Created by Jeffrey R Lewis on 1/3/18.
//  Copyright © 2018 4inunison. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet var titleLabel : UILabel!

    var isBeforeStart : Bool = false
    var tableController : NotificationTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = isBeforeStart ? "Reminders before period begins" : "Reminders before period ends"
        for child in childViewControllers {
            if let controller = child as? NotificationTableViewController {
                tableController = controller
            }
        }
    }

    @IBAction func close(_ : AnyObject) {
        dismiss(animated: true) {
            // self.updateDurations()
            saveAndSchedule(clearExisting: true)
        }
    }

}
