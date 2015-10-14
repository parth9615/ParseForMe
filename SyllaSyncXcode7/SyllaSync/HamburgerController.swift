//
//  HamburgerController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

public enum HamburgerCells: Int {
    case Filler = 0
    case Calendar
    case Notifications
    case Settings
    case ViewSyllabi
    case AboutUs
    case Logout
    case Fluff
}

class HamburgerController: UITableViewController {
    
    var parent:EventsContainerController?
    var toggleCell:ToggleCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 8
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == HamburgerCells.Filler.rawValue {
            let cellIdentifier = "Filler"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = UIColor(rgba: "#04a4ca")
            return cell
        }
        else if indexPath.row == HamburgerCells.Calendar.rawValue {
            let cellIdentifier = "Toggle"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? ToggleCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? ToggleCell
            }
            toggleCell = cell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        else if indexPath.row == HamburgerCells.Notifications.rawValue {
            let cellIdentifier = "Notifications"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell

        }
        else if indexPath.row == HamburgerCells.Settings.rawValue {
            let cellIdentifier = "Settings"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if indexPath.row == HamburgerCells.ViewSyllabi.rawValue {
            let cellIdentifier = "ViewSyllabi"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell

        }
        else if indexPath.row == HamburgerCells.AboutUs.rawValue {
            let cellIdentifier = "AboutUs"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if indexPath.row == HamburgerCells.Logout.rawValue {
            let cellIdentifier = "Logout"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else {
            let cellIdentifier = "Fluff"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == HamburgerCells.Filler.rawValue {
            return 175
        }
        if indexPath.row == HamburgerCells.ViewSyllabi.rawValue || indexPath.row == HamburgerCells.Notifications.rawValue || indexPath.row == HamburgerCells.Settings.rawValue || indexPath.row == HamburgerCells.AboutUs.rawValue || indexPath.row == HamburgerCells.Logout.rawValue || indexPath.row == HamburgerCells.Calendar.rawValue {
            return 45
        }
        else {
            return 500
        }
    }
    
    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the specified item to be editable.
    //        return false
    //    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        if indexPath.row == HamburgerCells.Settings.rawValue {
            //go to new page
            let settingsVC = self.storyboard?.instantiateViewControllerWithIdentifier("Settings") as! SettingsController
            self.presentViewController(settingsVC, animated: true, completion: nil)
        }
        else if indexPath.row == HamburgerCells.Calendar.rawValue {
            parent?.toggleLeftPanel(self)
            parent?.tableCalendarController?.toggleViews()
            if self.toggleCell!.label.text == "Table View"{
                self.toggleCell!.label.text = "Calendar View"
            }
            else {
                self.toggleCell!.label.text = "Table View"
            }
            
        }
        else if indexPath.row == HamburgerCells.AboutUs.rawValue {
            //go to new page
            let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("AboutUs") as! AboutController
            self.presentViewController(aboutVC, animated: true, completion: nil)
        }
        else if indexPath.row == HamburgerCells.Notifications.rawValue {
            
            let notificationsVC = self.storyboard?.instantiateViewControllerWithIdentifier("Notifications") as! NotificationsController
            self.presentViewController(notificationsVC, animated: true, completion: nil)
        }
        else if indexPath.row == HamburgerCells.ViewSyllabi.rawValue {
            
            let inviteVC = self.storyboard?.instantiateViewControllerWithIdentifier("Syllabi") as! SyllabiController
            self.presentViewController(inviteVC, animated: true, completion: nil)
        }
        else if indexPath.row == HamburgerCells.Logout.rawValue {
            
            let logoutVC = self.storyboard?.instantiateViewControllerWithIdentifier("Logout") as! LogoutController
            self.presentViewController(logoutVC, animated: true, completion: nil)
        }
        else {
            
            
        }
    }

}
