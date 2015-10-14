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

class NotificationsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var notificationsTableView: UITableView!
    //
    //  HamburgerController.swift
    //  SyllaSync
    //
    //  Created by Joel Wasserman on 8/1/15.
    //  Copyright (c) 2015 IVET. All rights reserved.
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("stuff has happened", terminator: "")
        //self.tableView.scrollEnabled = false //comment to enable scrolling
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == NotificationCells.BarEvents.rawValue {
            let cellIdentifier = "BarEvents"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else {
//            if indexPath.row == NotificationCells.SportEvents.rawValue {
            let cellIdentifier = "SportEvents"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the specified item to be editable.
    //        return false
    //    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
