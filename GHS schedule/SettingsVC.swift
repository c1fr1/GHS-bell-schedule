//
//  SettingsVCViewController.swift
//  GHS schedule
//
//  Created by C1FR1 on 11/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
	@IBAction func goBack(_ sender: Any) {
		dismiss(animated: true) {
		}
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NotificationViewController {
            dest.isBeforeStart = segue.identifier == "PeriodBegins"
        }
    }
}
