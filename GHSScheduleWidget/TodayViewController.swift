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
    @IBOutlet weak var timeTill: UILabel!
    
    override func viewDidLoad() {
        let data = getStoredScheduleInfo()
        periodInfo.text = "\(data.count)"
        super.viewDidLoad()
    }
    func getStoredScheduleInfo() -> [String:[[String:String]]] {
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
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
