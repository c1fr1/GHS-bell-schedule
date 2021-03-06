//
//  File.swift
//  GHS schedule
//
//  Created by C1FR1 on 10/25/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class Keys {
	static let DATEKEY = "GHSSDATE"
    static let VERSIONDATEKEY = "GHSSVERSD"
	static let VERSIONKEY = "GHSSVERS"
	
    static let P1KEY = "GHSP1"
    static let P2KEY = "GHSP2"
    static let P3KEY = "GHSP3"
    static let P4KEY = "GHSP4"
    static let P5KEY = "GHSP5"
    static let P6KEY = "GHSP6"
    static let P7KEY = "GHSP7"
    static let P8KEY = "GHSP8"
    static let FLEXKEY = "GHSFLEX"
    static let LUNCHKEY = "GHSLUNCH"

	static let P1DURATIONKEY = "GHSP1DURATION"
	static let P2DURATIONKEY = "GHSP2DURATION"
	static let P3DURATIONKEY = "GHSP3DURATION"
	static let P4DURATIONKEY = "GHSP4DURATION"
	static let P5DURATIONKEY = "GHSP5DURATION"
	static let P6DURATIONKEY = "GHSP6DURATION"
	static let P7DURATIONKEY = "GHSP7DURATION"
	static let P8DURATIONKEY = "GHSP8DURATION"
	static let FLEXDURATIONKEY = "GHSFLEXDURATION"
	static let LUNCHDURATIONKEY = "GHSLUNCHDURATION"
	
	static let P1DURATIONEKEY = "GHSP1DURATIONEND"
	static let P2DURATIONEKEY = "GHSP2DURATIONEND"
	static let P3DURATIONEKEY = "GHSP3DURATIONEND"
	static let P4DURATIONEKEY = "GHSP4DURATIONEND"
	static let P5DURATIONEKEY = "GHSP5DURATIONEND"
	static let P6DURATIONEKEY = "GHSP6DURATIONEND"
	static let P7DURATIONEKEY = "GHSP7DURATIONEND"
	static let P8DURATIONEKEY = "GHSP8DURATIONEND"
	static let FLEXDURATIONEKEY = "GHSFLEXDURATIONEND"
	static let LUNCHDURATIONEKEY = "GHSLUNCHDURATIONEND"
	
	static let P1CLASSKEY = "GHSP1CLASS"
	static let P2CLASSKEY = "GHSP2CLASS"
	static let P3CLASSKEY = "GHSP3CLASS"
	static let P4CLASSKEY = "GHSP4CLASS"
	static let P5CLASSKEY = "GHSP5CLASS"
	static let P6CLASSKEY = "GHSP6CLASS"
	static let P7CLASSKEY = "GHSP7CLASS"
	static let P8CLASSKEY = "GHSP8CLASS"
	
	static let P1ROOMKEY = "GHSP1ROOM"
	static let P2ROOMKEY = "GHSP2ROOM"
	static let P3ROOMKEY = "GHSP3ROOM"
	static let P4ROOMKEY = "GHSP4ROOM"
	static let P5ROOMKEY = "GHSP5ROOM"
	static let P6ROOMKEY = "GHSP6ROOM"
	static let P7ROOMKEY = "GHSP7ROOM"
	static let P8ROOMKEY = "GHSP8ROOM"
	
	static let PERIODINFOKEY = "GHSPERIODTIMES"
	static let FULLSCHEDULEDATESKEY = "GHSFULLSCHEDULEKEYD"
	static let FULLSCHEDULESTRINGSSKEY = "GHSFULLSCHEDULEKEYS"
}

var groupDefaults:UserDefaults {
    return UserDefaults(suiteName: "group.com.catana-software.grantBellSchedule")!
}
