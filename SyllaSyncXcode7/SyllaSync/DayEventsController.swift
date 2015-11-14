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
    var eventDates = [String]()
    var eventTimes = [String]()
    var eventLocations = [String]()
    var eventWeights = [Int]()
    
    var titleString = ""
    var weightInt = 0
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
        cell?.eventDate.text = "Worth \(eventWeights[indexPath.row])% of your grade"
        cell?.eventLocation.text = ""
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (UITableViewRowAction, indexPath) -> Void in
            //edit
            let alert = UIAlertController(title: "Edit Event", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({(textField1: UITextField!) in
                textField1.text = self.eventTitles[indexPath.row]
                textField1.placeholder = "Event Title"
                textField1.textAlignment = NSTextAlignment.Center
            })
            alert.addTextFieldWithConfigurationHandler({(textField2: UITextField!) in
                textField2.text = self.eventDates[indexPath.row]
                textField2.placeholder = "Event Date"
                textField2.textAlignment = NSTextAlignment.Center
                textField2.addTarget(self, action: "editingTextField2:", forControlEvents: UIControlEvents.EditingChanged)
                
            })
            alert.addTextFieldWithConfigurationHandler({(textField3: UITextField!) in
                textField3.text = self.eventTimes[indexPath.row]
                textField3.placeholder = "Event Time"
                textField3.textAlignment = NSTextAlignment.Center
            })
            alert.addTextFieldWithConfigurationHandler({(textField4: UITextField!) in
                textField4.text = "\(self.eventWeights[indexPath.row])"
                textField4.placeholder = "Event Weight"
                textField4.textAlignment = NSTextAlignment.Center
                textField4.addTarget(self, action: "editingTextField4:", forControlEvents: UIControlEvents.EditingChanged)
                
            })
            let OKAction = UIAlertAction(title: "Finish Editing", style: .Default) { _ in
                self.checkEditInput(alert.textFields!)
                
            }
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor.blueColor()
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (UITableViewRowAction, indexPath) -> Void in
            // handle delete (by removing the data from your array and updating the tableview
            self.titleString = self.eventTitles[indexPath.row]
            self.weightInt = self.eventWeights[indexPath.row]
            self.timeString = self.eventTimes[indexPath.row]
            self.deleteEvent(self.parentViewController as! CalendarController)
        }

        return [editAction, deleteAction]
    }
    
    func editingTextField2(sender: UITextField) {
        let regexPatterns = ["^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d$"]
        
        let regexes = try! NSRegularExpression(pattern: regexPatterns[0], options: [])
        
        let text = sender.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let range = NSMakeRange(0, text.length)
        
        let matchRange = regexes.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
        
        let valid = matchRange.location != NSNotFound
        
        sender.textColor = (valid) ? UIColor.blackColor() : UIColor.redColor()
    }
    
    func editingTextField4(sender: UITextField) {
        let regexPatterns = ["^\\d\\d"]
        
        let regexes = try! NSRegularExpression(pattern: regexPatterns[0], options: [])
        
        let text = sender.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let range = NSMakeRange(0, text.length)
        
        let matchRange = regexes.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
        
        let valid = matchRange.location != NSNotFound
        
        sender.textColor = (valid) ? UIColor.blackColor() : UIColor.redColor()
    }
    
    func checkEditInput(textFields: [UITextField]) {
        
  
        for each in textFields {
            if each.text != "" {
                continue
            }
            else {
                //one of the input fields was blank
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func deleteEvent(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { _ in
            self.numberOfEventsOnDay--
            
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
