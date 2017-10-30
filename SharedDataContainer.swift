//
//  File.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 10/25/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class Keys {
	static let DATEKEY = "GHSSDATE"
	static let VERSIONKEY = "GHSSVERS"
	static let P1DURATIONKEY = "GHSP1DURATION"
	static let P2DURATIONKEY = "GHSP2DURATION"
	static let P3DURATIONKEY = "GHSP3DURATION"
	static let P4DURATIONKEY = "GHSP4DURATION"
	static let P5DURATIONKEY = "GHSP5DURATION"
	static let P6DURATIONKEY = "GHSP6DURATION"
	static let P7DURATIONKEY = "GHSP7DURATION"
	static let P8DURATIONKEY = "GHSP8DURATION"
	static let PERIODINFOKEY = "GHSPERIODTIMES"
	static let FULLSCHEDULEDATESKEY = "GHSFULLSCHEDULEKEYD"
	static let FULLSCHEDULESTRINGSSKEY = "GHSFULLSCHEDULEKEYS"
}

var groupDefaults:UserDefaults {
    return UserDefaults(suiteName: "group.com.catana-software.grantBellSchedule")!
}
