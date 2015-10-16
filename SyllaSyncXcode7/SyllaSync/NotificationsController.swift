//
//  CompareController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

public enum NotificationCells: Int {
    case BarEvents = 0
    case SportEvents
}

class NotificationsController: UIViewController {
    
    @IBOutlet weak var barEventsToggle: UISwitch!
    @IBOutlet weak var sportEventsToggle: UISwitch!

    //
    //  HamburgerController.swift
    //  SyllaSync
    //
    //  Created by Joel Wasserman on 8/1/15.
    //  Copyright (c) 2015 IVET. All rights reserved.
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barEventsToggle.addTarget(self, action: Selector("barStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        sportEventsToggle.addTarget(self, action: Selector("sportStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.scrollEnabled = false //comment to enable scrolling
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func barStateChanged(switchState: UISwitch) {
        if switchState.on {
            UserSettings.sharedInstance.BarEvents = true
        } else {
            UserSettings.sharedInstance.BarEvents = false
        }
    }
    
    func sportStateChanged(switchState: UISwitch) {
        if switchState.on {
            UserSettings.sharedInstance.SportEvents = true
        } else {
            UserSettings.sharedInstance.SportEvents = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the specified item to be editable.
    //        return false
    //    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
