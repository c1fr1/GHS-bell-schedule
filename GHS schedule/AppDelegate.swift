//
//  AppDelegate.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

var schedule:[Date:String]?
var periodInfo:[String:[[String:String]]]?
var periodInfoRawJson:Data!
var notificationSettings:Bool?

//A: it is not during the school day, checked version number and it is the same, so grabbing stored data
//B: it is not during the school day, checked version number and it is not up to date, download schedule
//C: defaults are nil, it is assumed the app has not been ran on this device yet, download schedule
//D: it is during the school day, download schedule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        startUp()
        return true
    }
    func startUp() {
        if let versChecked = UserDefaults.standard.value(forKey: "GHSSDATE") {
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
                let day = getdayNum(from: (selectedMonth, selectedDay!, selectedYear))//change this to 5 or six to say it is a weekend and actually "getData"
                if (((hrs > 8 && hrs < 16) || (mins >= 30 && hrs == 8)) && day != 6  && day != 0) || curDate.timeIntervalSince(date) < 180 {//any time after school, or any time during weekend
                    schedule = getStoredData()//D
                    periodInfo = getStoredScheduleInfo()
                    if schedule!.count == 0 {
                        schedule = getDatesInfo()
                    }
                    if periodInfo!.count == 0 {
                        periodInfo = getScheduleInfo()
                    }
                }else {
                    getData()
                    UserDefaults.standard.set(curDate, forKey: "GHSSDATE")
                }
            }else {
                getData()
                UserDefaults.standard.set(curDate, forKey: "GHSSDATE")
            }
        }else {
            getData()
            UserDefaults.standard.set(curDate, forKey: "GHSSDATE")
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
        p1Duration = UserDefaults.standard.value(forKey: "GHSP1DURATION") as? Double
        p2Duration = UserDefaults.standard.value(forKey: "GHSP2DURATION") as? Double
        p3Duration = UserDefaults.standard.value(forKey: "GHSP3DURATION") as? Double
        p4Duration = UserDefaults.standard.value(forKey: "GHSP4DURATION") as? Double
        p5Duration = UserDefaults.standard.value(forKey: "GHSP5DURATION") as? Double
        p6Duration = UserDefaults.standard.value(forKey: "GHSP6DURATION") as? Double
        p7Duration = UserDefaults.standard.value(forKey: "GHSP7DURATION") as? Double
        p8Duration = UserDefaults.standard.value(forKey: "GHSP8DURATION") as? Double
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {//NOTIFICATIONSS
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let generalCategory = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [], options: .customDismissAction)
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory])
    }//NOTIFICATIONE
    func getData() {
        let versionNumDefault = UserDefaults.standard.value(forKey: "GHSSVERS")
        let versionNum:Int? = versionNumDefault as? Int
        var data:Data?
        var obj:[String:Any]?
        do {
            data = try Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/versionNumber.json")!)
            obj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
            let rVersNum = Int(obj!["VERSION"] as! String)!
            if versionNum != nil {
                if rVersNum == versionNum! {
                    //A
                    schedule = getStoredData()
                    periodInfo = getStoredScheduleInfo()
                    if schedule!.count == 0 {
                        schedule = getDatesInfo()
                    }
                    if periodInfo!.count == 0 {
                        periodInfo = getScheduleInfo()
                    }
                }else {
                    //B
                    schedule = getDatesInfo()
                    if schedule!.count == 0 {
                        schedule = getStoredData()
                    }
                    periodInfo = getScheduleInfo()
                    if periodInfo!.count == 0 {
                        periodInfo = getStoredScheduleInfo()
                    }
                    UserDefaults.standard.setValue(rVersNum, forKey: "GHSSVERS")
                    deleteStoredData(iN: persistentContainer.viewContext)
                }
            }else {
                //C
                schedule = getDatesInfo()
                periodInfo = getScheduleInfo()
                UserDefaults.standard.setValue(rVersNum, forKey: "GHSSVERS")
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (accepted, error) in
                    print("acceptedNotifications:\(accepted)")
                })
            }
        } catch _ as Error {
            if versionNum != nil {
                schedule = getStoredData()
                periodInfo = getStoredScheduleInfo()
            }
        }
    }
    func getDatesInfo() -> [Date:String] {
        var retval:[Date:String] = [:]
        do {
            let scheduleData = try Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/schoolYearSchedule.json")!)
            let scheduleStr = try JSONSerialization.jsonObject(with: scheduleData, options: .mutableContainers) as! [String:[[String:String]]]
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "PST")
            formatter.dateFormat = "yyyyMMdd"
            for dict in scheduleStr["VEVENT"]! {
                var date = dict["DTSTART;VALUE=DATE"]
                var ndate = ""
                for char in date!.characters {
                    if Int("\(char)") != nil {
                        ndate += "\(char)"
                    }
                }
                retval[formatter.date(from: ndate)!] = dict["SUMMARY"]
            }
            return retval
        } catch _ as NSError {
            return [:]
        }
    }
    func getScheduleInfo() -> [String:[[String:String]]] {
        var retval = [String:[[String:String]]]()
        let data = try! Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/periodSchedule.json")!)
        periodInfoRawJson = data
        if let lyr1 = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
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
    func getStoredScheduleInfo() -> [String:[[String:String]]] {
        if periodInfo != nil {
            if periodInfo!.count > 0 {
                return periodInfo!
            }
        }
        var retval = [String:[[String:String]]]()
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSPeriodTimes")
        var data:Data!
        do {
            let obj = try persistentContainer.viewContext.fetch(request)
            if obj.count == 0 {
                return [:]
            }
            data = obj.first!.value(forKey: "rawJson") as! Data
        } catch _ as NSError {
            print("dataMissing")
            return [:]
        }
        periodInfoRawJson = data
        if let lyr1 = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
            for element in lyr1! {
                if let lyr2 = element.value as? [[String:String]] {
                    retval[element.key] = lyr2
                }
            }
        }else {
            print("notWorking")
            return [:]
        }
        return retval
    }
    func getStoredData() -> [Date:String] {
        if schedule != nil {
            if schedule!.count > 0 {
                return schedule!
            }
        }
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSSchedule")
        do {
            var retVal:[Date:String] = [:]
            let scheduleList = try persistentContainer.viewContext.fetch(request)
            for obj in scheduleList {
                retVal[obj.value(forKey: "date") as! Date] = obj.value(forKey: "scheduleType") as? String
            }
            return retVal
        } catch let e {
            print("dataMissing\(e.localizedDescription)")
            return [:]
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSSchedule")
        let ctx = persistentContainer.viewContext
        if schedule!.count > 0 && (try! ctx.fetch(request).count) < 1 {
            //DOSTUFF
            
            let entity = NSEntityDescription.entity(forEntityName: "GHSSchedule", in: ctx)
            for element in schedule! {
                let obj = NSManagedObject(entity: entity!, insertInto: ctx)
                obj.setValue(element.key, forKey: "date")
                obj.setValue(element.value, forKey: "scheduleType")
            }
            let ent = NSEntityDescription.entity(forEntityName: "GHSPeriodTimes", in: ctx)!
            let obj = NSManagedObject(entity: ent, insertInto: ctx)
            obj.setValue(periodInfoRawJson, forKey: "rawJson")
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            // Saves changes in the application's managed object context before the application terminates.
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let ints = getDateInts()
        selectedMonth = ints.0
        selectedDay = ints.1
        selectedYear = ints.2
        startUp()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        notificationController?.saveAndSchedule()
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSSchedule")
        let ctx = persistentContainer.viewContext
        if schedule!.count > 0 && (try! ctx.fetch(request).count) < 1 {
            //DOSTUFF
            
            let entity = NSEntityDescription.entity(forEntityName: "GHSSchedule", in: ctx)
            for element in schedule! {
                let obj = NSManagedObject(entity: entity!, insertInto: ctx)
                obj.setValue(element.key, forKey: "date")
                obj.setValue(element.value, forKey: "scheduleType")
            }
            let ent = NSEntityDescription.entity(forEntityName: "GHSPeriodTimes", in: ctx)!
            let obj = NSManagedObject(entity: ent, insertInto: ctx)
            obj.setValue(periodInfoRawJson, forKey: "rawJson")
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            // Saves changes in the application's managed object context before the application terminates.
        }
        UserDefaults.standard.set(p1Duration, forKey: "GHSP1DURATION")
        UserDefaults.standard.set(p2Duration, forKey: "GHSP2DURATION")
        UserDefaults.standard.set(p3Duration, forKey: "GHSP3DURATION")
        UserDefaults.standard.set(p4Duration, forKey: "GHSP4DURATION")
        UserDefaults.standard.set(p5Duration, forKey: "GHSP5DURATION")
        UserDefaults.standard.set(p6Duration, forKey: "GHSP6DURATION")
        UserDefaults.standard.set(p7Duration, forKey: "GHSP7DURATION")
        UserDefaults.standard.set(p8Duration, forKey: "GHSP8DURATION")
        
        self.saveContext()
    }
    func deleteStoredData(iN ctx:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GHSSchedule")
        let fe2chRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GHSPeriodTimes")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let de2eteReqest = NSBatchDeleteRequest(fetchRequest: fe2chRequest)
        do {
            let container = NSPersistentContainer(name: "GHS_schedule")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            let coordinator = container.persistentStoreCoordinator
            try coordinator.execute(deleteRequest, with: ctx)
            try coordinator.execute(de2eteReqest, with: ctx)
        } catch _ as Error {
            print("RIP")
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GHS_schedule")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

let notificationIdentifier = "idforthign"

func scheduleNotification(period:String, interval:TimeInterval, forDate:(Int, Int, Int)) {
    let content = UNMutableNotificationContent()
    content.sound = UNNotificationSound.default()
    content.title = "\(period)"
    let mins = Int(floor(interval/60))
    let secs = Int(floor(interval)) - mins*60
    if mins == 0 {
        if secs == 0 {
            content.body = "\(period) starts in... well it just started, idk why you made this..."
        }else {
            content.body = "\(period) starts in \(secs) seconds"
        }
    }else {
        if secs == 0 {
            content.body = "\(period) starts in \(mins) minutes"
        }else {
            content.body = "\(period) starts in \(mins) minutes and \(secs)"
        }
    }
    
    var pnum:Int!
    for char in period.characters {
        if let int = Int(String(char)) {
            pnum = int
            break
        }
    }
    var comp = getStartTimeFor(period: pnum, on: forDate)
    if comp != nil {
        comp!.second = Int(-1*interval)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp!, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (e) in
            if let error = e {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

