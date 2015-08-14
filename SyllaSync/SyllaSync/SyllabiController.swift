//
//  SyllabiController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/14/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class SyllabiController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var syllabiTable: UITableView!
    var eventService = EventService.sharedInstance
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    syllabiTable.delegate = self
    syllabiTable.dataSource = self
    
    //self.view.backgroundColor = UIColor(rgba: "#04a4ca")
    
    //pull to refresh
    refreshControl = UIRefreshControl()
    self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
    self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    syllabiTable.addSubview(refreshControl)
    
    }
    
    func refresh() {
        eventService.getJSON(self)
        syllabiTable.reloadData()
    }
    
    func finishedLoading() {
    self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventService.headerCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cellIdentifier = "Syllabi"
    var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? SyllabiCell
    if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? SyllabiCell
    }
    
    
    cell?.eventName.text = eventService.eventsArrayTitles[indexPath.row + previousClasses]
    cell?.eventTime.text = eventService.eventsArrayTimes[indexPath.row + previousClasses]
    cell?.eventPlace.text = eventService.eventsArrayDates[indexPath.row + previousClasses]
    
    cell?.selectionStyle = UITableViewCellSelectionStyle.None
    return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 70
    }
    
    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the specified item to be editable.
    //        return false
    //    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
    //        if indexPath.row == HamburgerCells.Settings.rawValue {
    //            //go to new page
    //
    //        }
    //        else if indexPath.row == HamburgerCells.AboutUs.rawValue {
    //            //go to new page
    //
    //        }
    //        else if indexPath.row == HamburgerCells.Compare.rawValue {
    //
    //
    //        }
    //        else if indexPath.row == HamburgerCells.Invite.rawValue {
    //
    //
    //        }
    //        else {
    //
    //
    //        }
    }
    
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    }

}
