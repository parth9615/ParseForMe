//
//  HamburgerController.swift
//  ParseForMe
//
//  Created by Joel Wasserman on 7/24/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class HamburgerController: UITableViewController {

    var parent:EventsContainerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false //comment to enable scrolling
        
        
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
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cellIdentifier = "Filler"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        else if indexPath.row == 1 {
            var cellIdentifier = "Settings"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        else if indexPath.row == 2 {
            var cellIdentifier = "AboutUs"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        else {
            var cellIdentifier = "Fluff"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 175
        }
        if indexPath.row == 1 || indexPath.row == 2 {
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
        if indexPath.row == 1 {
            //go to new page
           
        }
        else if indexPath.row == 2 {
            //go to new page
            
        }
        else {
            
        }
    }
}
