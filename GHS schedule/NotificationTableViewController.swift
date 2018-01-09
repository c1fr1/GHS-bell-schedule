//
//  NotificationTableViewController.swift
//  GHS schedule
//
//  Created by Jeffrey R Lewis on 1/3/18.
//  Copyright © 2018 4inunison. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    var isBeforeStart : Bool {
        if let parent = parent as? NotificationViewController2
        {
            return parent.isBeforeStart
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periodsInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! NotificationTableViewCell

        if let period = Period(rawValue: indexPath.row),
           let info = periodsInfo[period]
        {
            cell.setup(controller: self, info: info)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton,
           let container = button.superview,
           let cell = container.superview as? NotificationTableViewCell,
           let notificationController = parent as? NotificationViewController2,
           let pickerController = segue.destination as? MMSSPickerViewController
        {
            pickerController.notificationController = notificationController
            pickerController.info = cell.info
        }
    }
}

class NotificationTableViewCell : UITableViewCell {
    @IBOutlet var label : UILabel!
    @IBOutlet var button : UIButton!
    @IBOutlet var enable : UISwitch!

    var controller : NotificationTableViewController?
    var info : PeriodInfo?

    var isBeforeStart : Bool {
        if let controller = controller
        {
            return controller.isBeforeStart
        }
        return false
    }

    func setup(controller c : NotificationTableViewController, info ii : PeriodInfo)
    {
        controller = c
        info = ii
        label.text = ii.name.value
        let duration = isBeforeStart ? ii.beforeDuration.value : ii.endDuration.value
        let mins = Int(floor(duration / 60))
        let secs = Int(duration) - mins * 60
        let mmss = String(format: "%02d:%02d", mins, secs)
        button.setTitle(mmss, for: .normal)
        enable.isOn = isBeforeStart ? ii.beforeEnabled.value : ii.endEnabled.value
    }
    
    @IBAction func enableChanged(_ : AnyObject) {
        if let info = info {
            if isBeforeStart {
                info.beforeEnabled.value = enable.isOn
            } else {
                info.endEnabled.value = enable.isOn
            }
        }
    }
}
