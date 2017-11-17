//
//  SettingsVCViewController.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 11/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
	@IBAction func goBack(_ sender: Any) {
		dismiss(animated: true) {
		}
	}
	@IBAction func beforeEnd(_ sender: Any) {
		beforeStart = false
	}
	@IBAction func beforeBegin(_ sender: Any) {
		beforeStart = true
	}
}
