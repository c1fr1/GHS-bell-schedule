//
//  AppDelegate.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import UserNotifications

var orderedSchedule:[(Date, String)] = []
var schedule:[Date:String] = [:]
var periodInfo:[String:[[String:String]]] = [:] // TODO: Is this the same as our `periods'??
var notificationSettings:Bool?

//A: it is not during the school day, checked version number and it is the same, so grabbing stored data
//B: it is not during the school day, checked version number and it is not up to date, download schedule
//C: defaults are nil, it is assumed the app has not been ran on this device yet, download schedule
//D: it is during the school day, download schedule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
	
	//AppDelegate functions
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        startUp()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		saveAndSchedule()
		storeInfo()
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		let ints = getDateInts()
		selectedMonth = ints.0
		selectedDay = ints.1
		selectedYear = ints.2
		startUp()
		UNUserNotificationCenter.current().delegate = self
		if mainVC != nil {
			mainVC!.updateDisplay()
			mainVC!.clayer.layoutCalendar()
		}
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		saveAndSchedule()
		storeInfo()
	}
	
    //Start of notification functions
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
	
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.sound)
    }
	
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.identifier)
    }
	
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let generalCategory = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [], options: .customDismissAction)
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory])
    }
	
	//Start of startup functions
	
	func startUp() {
		if let versChecked = groupDefaults.value(forKey: Keys.DATEKEY) {
			//if version number has been checked since 7:00 this morning, get stored info, otherwise, check vers num etc.
			let date = versChecked as! Date
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyyMMdd"
			formatter.timeZone = TimeZone(abbreviation: "PST")
			if formatter.string(from: curDate) == formatter.string(from: date) {
				formatter.dateFormat = "HH"
				let hrs = Int(formatter.string(from: date))!
				formatter.dateFormat = "mm"
				let mins = Int(formatter.string(from: date))!
				let day = getdayNum(from: (selectedMonth, selectedDay, selectedYear))//change this to 5 or six to say it is a weekend and actually "getData"
                if (((hrs > 8 && hrs < 16) || (mins >= 30 && hrs == 8)) && day != 6  && day != 0) || curDate.timeIntervalSince(date) < 180 {//any time after school, or any time during weekend
					var t = getStoredData()//D
					schedule = t.0
					orderedSchedule = t.1
					periodInfo = getStoredScheduleInfo()
					if schedule.count == 0 {
						t = getDatesInfo()
						schedule = t.0
						orderedSchedule = t.1
					}
					if periodInfo.count == 0 {
						periodInfo = getScheduleInfo()
					}
				}else {
					getData()
					groupDefaults.set(curDate, forKey: Keys.DATEKEY)
				}
			}else {
				getData()
				//UserDefaults(suiteName: "group.com.catana-software.grantBellSchedule")?.synchronize()
				groupDefaults.set(curDate, forKey: Keys.DATEKEY)
			}
		}else {
			getData()
			groupDefaults.set(curDate, forKey: Keys.DATEKEY)
		}
		UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
			if settings.authorizationStatus == .authorized {
				notificationSettings = true
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
			}else if settings.authorizationStatus == .denied {
				notificationSettings = false
			}else if settings.authorizationStatus == .notDetermined {
				UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (response, error) in
					notificationSettings = response
				})
			}
		})
		/*UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
			print("requestCount:", requests.count)
			for request in requests {
				print(request.identifier)
			}
		}*/
		saveAndSchedule()
	}
	
	func getData() {
		let versionNumDefault = groupDefaults.value(forKey: Keys.VERSIONKEY)
        let currScheduleDate = groupDefaults.value(forKey: Keys.VERSIONDATEKEY) as? Int
		let versionNum:Int? = versionNumDefault as? Int
		var data:Data?
		var obj:[String:Any]?
		do {
			data = try Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/versionNumber.json")!)
			obj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
			let rVersNum = Int(obj!["VERSION"] as! String)!
            let rDate = Int(obj!["DATE"] as! String)!
			if versionNum != nil && currScheduleDate != nil {
				if rDate <= currScheduleDate! {
                    if rVersNum <= versionNum! {
                        //A
                        var t = getStoredData()
                        schedule = t.0
                        orderedSchedule = t.1
                        periodInfo = getStoredScheduleInfo()
                        if schedule.count == 0 {
                            t = getDatesInfo()
                            schedule = t.0
                            orderedSchedule = t.1
                        }
                        if periodInfo.count == 0 {
                            periodInfo = getScheduleInfo()
                        }
                    }else {
                        //B old
                        var t = getDatesInfo()
                        schedule = t.0
                        orderedSchedule = t.1
                        if schedule.count == 0 {
                            t = getStoredData()
                            schedule = t.0
                            orderedSchedule = t.1
                        }
                        periodInfo = getScheduleInfo()
                        if periodInfo.count == 0 {
                            periodInfo = getStoredScheduleInfo()
                        }
                        groupDefaults.setValue(rVersNum, forKey: Keys.VERSIONKEY)
                        groupDefaults.setValue(rDate, forKey: Keys.VERSIONDATEKEY)
                    }
				}else {
					//B new
					var t = getDatesInfo()
					schedule = t.0
					orderedSchedule = t.1
					if schedule.count == 0 {
						t = getStoredData()
						schedule = t.0
						orderedSchedule = t.1
					}
					periodInfo = getScheduleInfo()
					if periodInfo.count == 0 {
						periodInfo = getStoredScheduleInfo()
					}
					groupDefaults.setValue(rVersNum, forKey: Keys.VERSIONKEY)
                    groupDefaults.setValue(rDate, forKey: Keys.VERSIONDATEKEY)
				}
			}else {
				//C
				let t = getDatesInfo()
				schedule = t.0
				orderedSchedule = t.1
				periodInfo = getScheduleInfo()
				groupDefaults.setValue(rVersNum, forKey: Keys.VERSIONKEY)
                groupDefaults.setValue(rDate, forKey: Keys.VERSIONDATEKEY)
				UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (accepted, error) in
					print("acceptedNotifications:\(accepted)")
				})
			}
		} catch _ {
			if versionNum != nil {
				let t = getStoredData()
				schedule = t.0
				orderedSchedule = t.1
				periodInfo = getStoredScheduleInfo()
			}
		}
	}
	
	//Load remote content
	
	func getDatesInfo() -> ([Date:String], [(Date, String)]) {
        print("loding remote")
		var reetval:[Date:String] = [:]
		var retval:[(Date, String)] = []
		do {
			let scheduleData = try Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/schoolYearSchedule.json")!)
			let scheduleStr = try JSONSerialization.jsonObject(with: scheduleData, options: .mutableContainers) as! [String:[[String:String]]]
			let formatter = DateFormatter()
			formatter.timeZone = TimeZone(abbreviation: "PST")
			formatter.dateFormat = "yyyyMMdd"
			for dict in scheduleStr["VEVENT"]! {
				let date = dict["DTSTART;VALUE=DATE"]
				var ndate = ""
				for char in date! {
					if Int("\(char)") != nil {
						ndate += "\(char)"
					}
				}
				reetval[formatter.date(from: ndate)!] = dict["SUMMARY"]
				if dict["SUMMARY"] != nil {
					retval.append((formatter.date(from: ndate)!, dict["SUMMARY"]!))
				}
			}
			retval.sort(by: { (a, b) -> Bool in
				return a.0 < b.0
			})
			return (reetval, retval)
		} catch _ as NSError {
			return ([:], [])
		}
	}
	
	func getScheduleInfo() -> [String:[[String:String]]] {
		var retval = [String:[[String:String]]]()
		let data = try? Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/periodSchedule.json")!)
		if data == nil {
			return [:]
		}
		if let lyr1 = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any] {
			for element in lyr1! {
				if let lyr2 = element.value as? [[String:String]] {
					retval[element.key] = lyr2
				}
			}
		}else {
			print("notWorking")
		}
		return retval
	}
	
	//Load/save stored content
	
	func getStoredScheduleInfo() -> [String:[[String:String]]] {//STOREDGET
        if periodInfo.count > 0 {
            return periodInfo
        }
		
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
	
	func getStoredData() -> ([Date:String], [(Date, String)]) {//STOREDGET
        print("storedDataGotten")
        if schedule.count > 0 {
            return (schedule, orderedSchedule)
        }
		
		let ds = groupDefaults.value(forKey: Keys.FULLSCHEDULEDATESKEY)
		if let dinfo = ds as? [Date] {
			let ss = groupDefaults.value(forKey: Keys.FULLSCHEDULESTRINGSSKEY)
			if let sinfo = ss as? [String] {
				var dictRVal:[Date:String] = [:]
				var ordRVal:[(Date, String)] = []
				for (num, d) in dinfo.enumerated() {
					dictRVal[d] = sinfo[num]
					ordRVal.append((d, sinfo[num]))
				}
				return (dictRVal, ordRVal)
			}
		}
		print("Failed to get valid schedule info")
		return ([:], [])
	}
	
    func storeInfo() {
		var dates:[Date] = []
		var strings:[String] = []
		for obj in orderedSchedule {
			dates.append(obj.0)
			strings.append(obj.1)
		}
		groupDefaults.setValuesForKeys([Keys.FULLSCHEDULEDATESKEY : dates as Any, Keys.FULLSCHEDULESTRINGSSKEY : strings as Any, Keys.PERIODINFOKEY: periodInfo as Any])
    }
}
@discardableResult func scheduleNotification(period : Period, interval:TimeInterval, forDate:(Int, Int, Int), last:Bool = false, start:Bool = true) -> Bool {
    let content = UNMutableNotificationContent()
    content.sound = UNNotificationSound.default()
    guard let info = periods[period]
        else { return false }
    let rPeriod = info.name
    content.title = rPeriod
	
    let mins = Int(floor(interval/60))
    let secs = Int(floor(interval)) - mins*60
    if mins == 0 {
        if secs == 0 {
			if start {
            	content.body = "\(rPeriod) starts in... well it just started, idk why you made this..."
			}else {
				content.body = "\(rPeriod) ends in... oh thats the bell, idk why you made this..."
			}
        }else {
			if start {
            	content.body = "\(rPeriod) starts in \(secs) seconds"
			}else {
				content.body = "\(rPeriod) ends in \(secs) seconds"
			}
        }
    }else {
        if secs == 0 {
			if start {
            	content.body = "\(rPeriod) starts in \(mins) minutes"
			}else {
				content.body = "\(rPeriod) ends in \(mins) minutes"
			}
        }else {
			if start {
            	content.body = "\(rPeriod) starts in \(mins) minutes and \(secs) seconds"
			}else {
				content.body = "\(rPeriod) ends in \(mins) minutes and \(secs) seconds"
			}
        }
    }
    if let room = info.room {
		content.body = "\(content.body)\n\(rPeriod) is in \(room)"
	}
    if last {
        content.body = "\(content.body) LAST NOTIFICATION open app to schedule more"
    }
    /*
    var pnum:Int!
    for char in period {
        if let int = Int(String(char)) {
            pnum = int
            break
        }
    }
	if period == "FLEX" {
		pnum = 9
	}else if period == "LUNCH" {
		pnum = 10
	} */
    var comp = getStartTimeFor(period: period, on: forDate)
	if !start {
		comp = getEndTimeFor(period: period, on: forDate)
	}
    if comp != nil {
        comp!.second = Int(-1*interval)
        while comp!.second! < 0 {
            comp!.minute! -= 1
            comp!.second! += 60
        }
        while comp!.minute! < 0 {
            comp!.hour! -= 1
            comp!.minute! += 60
        }
        let cal = Calendar(identifier: .gregorian)
        let date = cal.date(from: comp!)
        if date != nil {
            if date! > curDate {
                let trigger = UNCalendarNotificationTrigger(dateMatching: comp!, repeats: false)
                
                var notificationIdentifier = "ghsID\(period)\(forDate.0)\(forDate.1)\(forDate.2)"
				if !start {
					notificationIdentifier = "\(notificationIdentifier)E"
				}
				//print("text: \(content.body)")
				//print("notificationID: \(notificationIdentifier)")
                let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
				
                UNUserNotificationCenter.current().add(request) { (e) in
                    if let error = e {
                        print("error in adding request: \(error.localizedDescription)")
                    }
                }
                return true
            }
        }
    }
    return false
}

func saveAndSchedule(clearExisting : Bool = false) {
    if clearExisting {
        UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())()
    }
    var count = 0
    var index = 0
    while orderedSchedule.count > index {
        if getDate(from: getDateInts()) >= orderedSchedule[index].0 {
            index += 1
        }else {
            break
        }
    }
    index -= 1
    while count < 64 {
        if orderedSchedule.count <= index {
            break
        }
        if orderedSchedule.count > 0 {
            let ints = getIntsFor(date: orderedSchedule[index].0)
            count += scheduleNotifications(forDate: ints, remaining: 63 - count)
            index += 1
        }else {
            break
        }
    }
}

@discardableResult func scheduleNotifications(forDate date:(Int, Int, Int), remaining:Int) -> Int {
    var count = 0
    var durations : [(Period, TimeInterval, Bool)] = []
    for (period, info) in periods {
        if info.beforeEnabled {
            durations.append((period, info.beforeDuration, true))
        }
        if info.endEnabled {
            durations.append((period, info.endDuration, false))
        }
    }
    for (period, duration, start) in durations {
        if scheduleForPeriod(period: period, date: date, duration: duration, last: remaining - count == 0, start: start) {
            count += 1
        }
        if remaining - count == -1 {
            return count
        }
    }
    return count
}
func scheduleForPeriod(period: Period, date:(Int, Int, Int), duration:TimeInterval, last:Bool, start:Bool) -> Bool {
    print("schduling \(start ? "start" : "end") for \(period) on \(date)")
    if scheduleNotification(period: period, interval: duration, forDate: date, last: last, start: start) {
        return true
    }
    return false
}


func getGridFrom(width:CGFloat, date:(Int, Int, Int)) -> ([CGRect], [CGPoint]) {//belongs in calendarstuff, but... scope...
    var currentWeekDay = getdayNum(from: (date.0, 1, date.2))
    var row = 0
    var retval:[CGRect] = []
    var nsRetVal:[CGPoint] = []
    let dimension = (width-30)/7
    for day in 0..<getDayCount(forMonth: date.0, andYear: date.2) {
        retval.append(CGRect(x: 15 + CGFloat(currentWeekDay)*dimension, y: 130 + CGFloat(row)*30, width: dimension, height: 30))
        currentWeekDay += 1
        if currentWeekDay == 7 {
            currentWeekDay = 0
            row += 1
        }
        let stype = schedule[getDate(from: (date.0, day + 1, date.2))]
        if stype != nil {
            if stype == "NO-SCHOOL" || stype == "NO SCHOOL" || !periodInfo.keys.contains(stype!) {
                nsRetVal.append(CGPoint(x: retval.last!.midX, y: retval.last!.origin.y))
            }
        }else {
            nsRetVal.append(CGPoint(x: retval.last!.midX, y: retval.last!.origin.y))
        }
    }
    return (retval, nsRetVal)
}
