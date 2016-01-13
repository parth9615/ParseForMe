//
//  NotificationSettingsVC.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 11/17/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

public enum NotificationCells: Int {
    case RelayForLife = 0
    case ACappella
    case MemorialHall
    case BlackStudentMovement
    case CarolinaUnionActivitiesBoard
    case FreeFood
    case CampusY
    case ClubSports
    case BarEvents
    case CarolinaAthleticsAssociation
    
    static var count: Int { return NotificationCells.CarolinaAthleticsAssociation.rawValue + 1}
}

class NotificationSettingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NotificationCells.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelCell", forIndexPath: indexPath) as! ChannelCell

        // Configure the cell...
        cell.groupIndex = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        switch(indexPath.row) {
        case 0:
            cell.channelName.text = "Relay For Life"
            if UserSettings.sharedInstance.RelayForLife == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 1:
            cell.channelName.text = "A Cappella"
            if UserSettings.sharedInstance.ACappella == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 2:
            cell.channelName.text = "Memorial Hall"
            if UserSettings.sharedInstance.MemorialHall == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 3:
            cell.channelName.text = "Black Student Movement"
            if UserSettings.sharedInstance.BlackStudentMovement == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }

        case 4:
            cell.channelName.text = "CUAB"
            if UserSettings.sharedInstance.CUAB == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 5:
            cell.channelName.text = "Free Food"
            if UserSettings.sharedInstance.FreeFood == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 6:
            cell.channelName.text = "Campus Y"
            if UserSettings.sharedInstance.CampusY == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 7:
            cell.channelName.text = "Club Sports"
            if UserSettings.sharedInstance.ClubSports == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 8:
            cell.channelName.text = "Bar Events"
            if UserSettings.sharedInstance.BarEvents == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        case 9:
            cell.channelName.text = "Carolina Athletic Association"
            if UserSettings.sharedInstance.CAA == true {
                cell.channelState.setOn(true, animated: false)
            }
            else {
                cell.channelState.setOn(false, animated: false)
            }
        default:
            print("should never hit this line 82 notificationSettingsVC")
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
