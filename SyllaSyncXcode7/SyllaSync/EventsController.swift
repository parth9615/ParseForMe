    //
//  EventsController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

@objc
public protocol EventsContainerControllerDelegate {
    optional func toggleLeftPanel(sender: AnyObject)
    optional func collapseSidePanels()
}

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titleString = ""
    var dateString = ""
    var timeString = ""
    
    @IBOutlet weak var eventsTable: UITableView!
    var itemIndex: Int = 1
    var calendarController:CalendarController?

    var previousClasses:Int = 0
    var refreshControl:UIRefreshControl!
    var eventService = EventService.sharedInstance
    var eventAddedTable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        eventsTable.addSubview(refreshControl)
  
    }
    
    func refresh() {
        eventService.getJSON(self)
    }
    
    func finishedLoading() {
        eventsTable.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if eventAddedTable {
            eventAddedTable = false
            
            calendarController!.getCVDatesFromDatesArray() {
                (result: String) in
                for each in self.calendarController!.calendarView.contentController.presentedMonthView.weekViews {
                    for dayView in each.dayViews {
                        for eachDate in self.calendarController!.CVDatesArray {
                            if dayView.date.day == eachDate.day && dayView.date.month == eachDate.month && dayView.date.year == eachDate.year {
                                dayView.preliminarySetup()
                                dayView.supplementarySetup()
                            }
                        }
                    }
                }
            }
            
            refresh()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventService.uniqueClasses.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventService.eventSectionCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        
        let indexPathSection = indexPath.section
        previousClasses = 0
        for var i = indexPathSection-1; i >= 0; i-- {
            previousClasses += eventService.eventSectionCount[i]
        }
        //cell?.backgroundColor = UIColor(rgba: "#04a4ca")//.colorWithAlphaComponent(0.2)
        cell?.eventName.text = eventService.eventsArray[indexPath.row + previousClasses].title
        cell?.eventTime.text = eventService.eventsArray[indexPath.row + previousClasses].time
        cell?.eventDate.text = eventService.eventsArray[indexPath.row + previousClasses].date
        cell?.eventLocation.text = ""
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width/1.5, 20))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.center = CGPoint(x: self.view.bounds.size.width/2, y:11)
        label.layer.borderColor = UIColor.lightGrayColor().CGColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        
        label.font = UIFont(name: "BoosterNextFY-Medium", size: 15)
        
        label.text = eventService.uniqueClasses[section]
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(label)
        return view
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        let HamburgerStoryBoard = UIStoryboard(name: "Hamburger", bundle: nil)
        let descriptionController = HamburgerStoryBoard.instantiateViewControllerWithIdentifier("EventTodayDescriptionController") as? EventTodayDescriptionController
        
        let indexPathSection = indexPath.section
        previousClasses = 0
        for var i = indexPathSection-1; i >= 0; i-- {
            previousClasses += eventService.eventSectionCount[i]
        }
        if let eclass = self.eventService.eventsArray[indexPath.row + previousClasses].className {
            descriptionController!.eventClass = "Class: \(eclass)"
        }
        else {
            descriptionController!.eventClass = "Class:"
        }
        if let title = self.eventService.eventsArray[indexPath.row + previousClasses].title {
            descriptionController!.eventTitle = "Title: \(title)"
        }
        else {
            descriptionController!.eventTitle = "Title:"
        }
        if let location = self.eventService.eventsArray[indexPath.row + previousClasses].location {
            descriptionController!.location = "Location: \(location)"
        }
        else {
            descriptionController!.locationHidden = true
        }
        if let time = self.eventService.eventsArray[indexPath.row + previousClasses].time {
            descriptionController!.time = "Time: \(time)"
        }
        else {
            descriptionController!.time = "Time:"
        }
        if let price = self.eventService.eventsArray[indexPath.row + previousClasses].price {
            descriptionController!.price = "Price: \(price)"
        }
        else {
            descriptionController!.priceHidden = true
        }
        if let group = self.eventService.eventsArray[indexPath.row + previousClasses].group {
            descriptionController!.group = "Group: \(group)"
        }
        else {
            descriptionController!.groupHidden = true
        }
        if let description = self.eventService.eventsArray[indexPath.row + previousClasses].eventDescription {
            descriptionController!.eventDescription = "Description: \(description)"
        }
        else {
            descriptionController!.eventDescription = "Description:"
        }
        self.view.window?.rootViewController?.presentViewController(descriptionController!, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (UITableViewRowAction, indexPath) -> Void in
            // handle delete (by removing the data from your array and updating the tableview
            let indexPathSection = indexPath.section
            var previousClasses2 = 0
            for var i = indexPathSection-1; i >= 0; i-- {
                previousClasses2 += self.eventService.eventSectionCount[i]
            }
            //cell?.backgroundColor = UIColor(rgba: "#04a4ca")//.colorWithAlphaComponent(0.2)
            self.titleString = self.eventService.eventsArray[indexPath.row + previousClasses2].title!
            self.timeString = self.eventService.eventsArray[indexPath.row + previousClasses2].time!
            self.dateString = self.eventService.eventsArray[indexPath.row + previousClasses2].date!
            self.deleteEvent()
        }
        
        return [deleteAction]
        //return [editAction, deleteAction] if want to have edit and delete as options
    }
    
    func deleteEvent() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { _ in
            
            let query:PFQuery = PFQuery(className: "Events")
            query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error:NSError?) -> Void in
                if (error == nil) {
                    print("got a query for \(UserSettings.sharedInstance.Username)")
                    if let object = objects as? [PFObject!] {
                        for each in object {
                            if let event:AnyObject = each {
                                if let eventDetails:AnyObject = event["events"] {
                                    var title = ""
                                    var className = ""
                                    var date = ""
                                    
                                    if let eventTitle:AnyObject = eventDetails["Title"] {
                                        title = "\(eventTitle)"
                                    }
                                    if let eventClassName:AnyObject = eventDetails["Classname"] {
                                        className = "\(eventClassName)"
                                    }
                                    
                                    if let eventDate:AnyObject = eventDetails["Date"] {
                                        date = eventDate as! String
                                        
                                        if date == self.dateString && title == self.titleString {
                                            each.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                                if success {
                                                    self.finishDeletion(className, date: date, title: title)
                                                    print("event was deleted succesfully")
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    print("Error getting query", error, error!.userInfo)
                    self.deletionError()
                }
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { _ in
        }
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func deletionError() {
        let innerAlert = UIAlertController(title: "", message: "Error deleting event (could be your internet), please try again", preferredStyle: .Alert)
        let OKAction2 = UIAlertAction(title: "Ok", style: .Default) { _ in
        }
        innerAlert.addAction(OKAction2)
        self.presentViewController(innerAlert, animated: true, completion: nil)
    }
    
    func finishDeletion(className: String, date: String, title: String) {
        let deletionUUID = className+date+title
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["UUID"] as! String == deletionUUID {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
        for each in UserSettings.sharedInstance.notificationsScheduled {
            if each.0 == deletionUUID {
                UserSettings.sharedInstance.notificationsScheduled.removeValueForKey(each.0)
            }
        }
        var i = 0
        for each in eventService.eventsArray {
            if each.UUID == deletionUUID {
                eventService.eventsArray.removeAtIndex(i)
                self.refresh()
                return
            }
            i++
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UIColor {
    public convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
