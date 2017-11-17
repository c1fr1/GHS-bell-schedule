//
//  TodayViewController.swift
//  GHSScheduleWidget
//
//  Created by Varas Pendragon on 10/24/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var periodInfo: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var timeTill: UILabel!
    
    override func viewDidLoad() {
        let data = getStoredScheduleInfo()
 		let dayType = getStoredData()[getDate(from: getDateInts())]
		if dayType != nil {
			let dayInfo = data[dayType!]
			if dayInfo != nil {
				var beforePeriod = false
				var curPeriod:[String:String]?
				let cal = Calendar(identifier: .gregorian)
				let formatter = DateFormatter()
				formatter.calendar = Calendar(identifier: .gregorian)
				formatter.timeZone = TimeZone(identifier: "PST")
				formatter.dateFormat = "hh:mm aa"
				let curDat = cal.date(from: getf(text: ["END":formatter.string(from: Date())]))!
				for period in dayInfo! {
					let startTime = cal.date(from: gbtf(text: period))!
					let endTime = cal.date(from: getf(text: period))!
					if startTime > curDat {
						if let pnum = period["NAME"] {
							if pnum == "P1" || pnum == "P5" {
								let intv = startTime.timeIntervalSince(curDat)
								if intv < 3600 || intv >= 0 {
									beforePeriod = true
									curPeriod = period
									break
								}
							}
						}
						let intv = startTime.timeIntervalSince(curDat)
						if intv < 600 && intv >= 0 {
							beforePeriod = true
							curPeriod = period
							break
						}
					}else if endTime > curDat {
						curPeriod = period
						break
					}
				}
				if curPeriod != nil {
					if beforePeriod {
						let pnum = curPeriod!["NAME"]
						if pnum == "P1" || pnum == "P5" {
							let mins = Int(floor(cal.date(from: gbtf(text: curPeriod!))!.timeIntervalSince(curDat)/60))
							periodInfo.text = "Before school on \(dayType!) day"
							timeLabel.text = ""
							if mins > 1 {
								timeTill.text = "Starts in \(mins) minutes"
							}else if mins == 1 {
								timeTill.text = "Starts in a minute"
							}else {
								timeTill.text = "Starts in less than a minute"
							}
						}else {
							let mins = Int(floor(cal.date(from: gbtf(text: curPeriod!))!.timeIntervalSince(curDat)/60))
							periodInfo.text = pnum
							timeLabel.text = "from \(curPeriod!["START"]!) to \(curPeriod!["END"]!)"
							if mins > 1 {
								timeTill.text = "Starts in \(mins) minutes"
							}else if mins == 1 {
								timeTill.text = "Starts in a minute"
							}else {
								timeTill.text = "Starts in less than a minute"
							}
						}
					}else {
						periodInfo.text = curPeriod!["NAME"]!
						timeLabel.text = "from \(curPeriod!["START"]!) to \(curPeriod!["END"]!)"
						let seconds = cal.date(from: getf(text: curPeriod!))!.timeIntervalSince(curDat)
						let mins = Int(floor(seconds/60))
						if mins > 1 {
							timeTill.text = "Ends in \(mins) minutes"
						}else if mins == 1 {
							timeTill.text = "Ends in a minute"
						}else {
							timeTill.text = "Ends in less than a minute"
						}
					}
				}else {
					periodInfo.text = "no current period"
					timeLabel.text = ""
					timeTill.text = ""
				}
			}else {
				periodInfo.text = "no current period"
				timeLabel.text = ""
				timeTill.text = ""
			}
		}else {
			periodInfo.text = "no current period"
			timeLabel.text = ""
			timeTill.text = ""
		}
        super.viewDidLoad()
    }
    func getStoredScheduleInfo() -> [String:[[String:String]]] {
		let retval = groupDefaults.value(forKey: Keys.PERIODINFOKEY)
		if retval != nil {
			if let info = retval as? [String:[[String:String]]] {
				return info
			}else {
				print("Failure to recognize Period info")
				return [:]
			}
		}else {
			print("Period info missing")
			return [:]
		}
    }
	func getStoredData() -> [Date:String] {
		let ds = groupDefaults.value(forKey: Keys.FULLSCHEDULEDATESKEY)
		if let dinfo = ds as? [Date] {
			let ss = groupDefaults.value(forKey: Keys.FULLSCHEDULESTRINGSSKEY)
			if let sinfo = ss as? [String] {
				var dictRVal:[Date:String] = [:]
				for (num, d) in dinfo.enumerated() {
					dictRVal[d] = sinfo[num]
				}
				return (dictRVal)
			}
		}
		print("Failed to get valid schedule info")
		return ([:])
	}
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
