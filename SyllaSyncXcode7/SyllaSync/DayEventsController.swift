//
//  DayEventsController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 11/13/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit
import CVCalendar

class DayEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventsTableView: UITableView!
    var numberOfEventsOnDay = 0
    var eventTitles = [String]()
    var eventTimes = [String]()
    var eventLocations = [String]()
    var eventWeights = [String]()
    
    var titleString = ""
    var weightString = ""
    var timeString = ""
    
    var eventService = EventService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTable() {
        eventsTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfEventsOnDay
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        
        cell?.eventName.text = eventTitles[indexPath.row]
        cell?.eventTime.text = eventTimes[indexPath.row]
        cell?.eventDate.text = eventWeights[indexPath.row]
        cell?.eventLocation.text = ""
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
    }
    
    

    
    
    func deleteEvent(sender: AnyObject) {
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
                                        let dateFromString = eventDate.componentsSeparatedByString("/")
                                        let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
                                        
                                        let parentVC = self.parentViewController as! CalendarController
                                        
                                        if newCVDate.day == parentVC.day?.date.day && newCVDate.month == parentVC.day?.date.month && title == self.titleString {
                                            each.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                                if success {
                                                    self.finishDeletion(className, date: date, title: title)
                                                    //print("\(self.titleLabel.text) event was deleted succesfully")
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
                break
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
                let parentVC = self.parentViewController as! CalendarController
                parentVC.finishLoading("deletion")
                return
            }
            i++
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
