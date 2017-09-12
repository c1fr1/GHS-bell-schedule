//
//  AppDelegate.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import CoreData

var schedule:[Date:String]!
var periodInfo:[String:[[String:String]]]!
var periodInfoRawJson:Data!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cPC:NSPersistentContainer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let versionNumDefault = UserDefaults.standard.value(forKey: "GHSSVERS")
        let versionNum:Int? = versionNumDefault as? Int
        let data = try! Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/versionNumber.json")!)
        let obj = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
        let rVersNum = Int(obj["VERSION"] as! String)!
        if versionNum != nil {
            if rVersNum == versionNum! {
                print("A")//up to date, grab saved schedule
                schedule = getStoredData()
                periodInfo = getStoredScheduleInfo()
            }else {
                //Get the data
                schedule = getDatesInfo()
                periodInfo = getScheduleInfo()
                UserDefaults.standard.setValue(rVersNum, forKey: "GHSSVERS")
                print("B")//not up to date download and parse schedule
            }
        }else {
            //get the data
            schedule = getDatesInfo()
            periodInfo = getScheduleInfo()
            UserDefaults.standard.setValue(rVersNum, forKey: "GHSSVERS")
            print("C")//first time starting app.
        }
        return true
    }
    func getDatesInfo() -> [Date:String] {
        var retval:[Date:String] = [:]
        let scheduleData = try! Data(contentsOf: URL(string: "http://www.grantcompsci.com/bellapp/schoolYearSchedule.json")!)
        let scheduleStr = String(describing: try! JSONSerialization.jsonObject(with: scheduleData, options: .mutableContainers) as! [String:Any])
        let allElements = parse(json: scheduleStr)
        //[[String:String]]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        for dict in allElements {
            var date = dict["VALUE"]
            var ndate = ""
            for char in date!.characters {
                if Int("\(char)") != nil {
                    ndate += "\(char)"
                }
            }
            retval[formatter.date(from: ndate)!] = dict["SUMMARY"]
        }
        return retval
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
        var retval = [String:[[String:String]]]()
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSPeriodTimes")
        var data:Data!
        do {
            let obj = try persistentContainer.viewContext.fetch(request)//empty
            data = obj.first!.value(forKey: "rawJson") as! Data//CRASH
        } catch _ as NSError {
            print("dataMissing")
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
        }
        return retval
    }
    func parse(json:String) -> [[String:String]] {
        var retVal:[[String:String]] = []
        var curDict:[String:String] = [:]
        var curVal = ""
        var curCharacteristicName = ""
        var onCharacteristicName:Bool = true
        var inElement:Bool = false
        for char in json.characters {
            if inElement {
                if char != " " && char != "\n" && char != "\"" {
                    if char != "}" {
                        if char == "=" {
                            onCharacteristicName = false
                        }else if char == ";" {
                            onCharacteristicName = true
                            curDict[curCharacteristicName] = curVal
                            curVal = ""
                            curCharacteristicName = ""
                        }else {
                            if onCharacteristicName {
                                curCharacteristicName = "\(curCharacteristicName)\(char)"
                            }else {
                                curVal = "\(curVal)\(char)"
                            }
                        }
                    }else {
                        retVal.append(curDict)
                        curDict = [:]
                        inElement = false
                    }
                }
            }else {
                if char == "{" {
                    inElement = true
                }
            }
        }
        return retVal
    }
    func getStoredData() -> [Date:String] {
        let request = NSFetchRequest<NSManagedObject>(entityName:"GHSSchedule")
        do {
            var retVal:[Date:String] = [:]
            let scheduleList = try persistentContainer.viewContext.fetch(request)
            print(scheduleList.count)
            for obj in scheduleList {
                retVal[obj.value(forKey: "date") as! Date] = obj.value(forKey: "scheduleType") as? String
            }
            return retVal
        } catch _ as NSError {
            print("dataMissing")
        }
        return [:]
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let ctx = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GHSSchedule", in: ctx)
        for element in schedule {
            let obj = NSManagedObject(entity: entity!, insertInto: ctx)
            obj.setValue(element.key, forKey: "date")
            obj.setValue(element.value, forKey: "scheduleType")
        }
        let ent = NSEntityDescription.entity(forEntityName: "GHSPeriodTimes", in: ctx)!
        let obj = NSManagedObject(entity: ent, insertInto: ctx)
        obj.setValue(periodInfoRawJson, forKey: "rawJson")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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

