//
//  EventService.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import CVCalendar
import SwiftyJSON

private let EventServiceInstance = EventService()

public struct EventServiceConstants {
    public static let EventAdded = "EventAdded"
    public static let EventDeleted = "EventDeleted"
}

public class EventService: NSObject {
    
    var userEventsFromParse:NSMutableArray?
    var eventsTodayFromParse:NSMutableArray?
    var eventsArray = [Event]()
    var eventsTodayArray = [Event]()
    var uniqueClasses = [String]()
    var eventSectionCount = [Int]()
    var deletion = false
    public class var sharedInstance : EventService {
        return EventServiceInstance
    }
    var notificationsScheduled = [String:Bool]()
    
    
    var data:NSMutableData?
    
    func useAPI() {
      //  let jsonFileURL = NSURL(string: "http://localhost:3000/api/2/events")
        
      //  let jsonFileRequest = NSURLRequest(URL: jsonFileURL!)
        
       // let conn = NSURLConnection(request: jsonFileRequest, delegate: self)
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data!.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        let json = JSON(data: self.data!)
        print("json:      \(json)")
            
    }
    
    
    
    
    func getJSON(sender: AnyObject) {
        //UserSettings.sharedInstance.notificationsScheduled.removeAll()
        
       // useAPI()
        uniqueClasses.removeAll()
        eventSectionCount.removeAll()
        
        
        let query:PFQuery = PFQuery(className: "Events")
        query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject!] {
                    
                    self.userEventsFromParse = NSMutableArray()
                    
                    self.userEventsFromParse!.addObjectsFromArray(objects)
                    
                    self.createEventObjects(sender)
                }
                else {
                    self.finish(sender)
                }
            }
            else {
                print("Error getting query", error, error!.userInfo)
            }
        }
    }
    
    func createEventObjects(sender: AnyObject) {
        if userEventsFromParse != nil {
            for each in userEventsFromParse! {
                if let eventDetails:AnyObject = each["events"] {
                    
                    let event = Event()
                    event.className = eventDetails["Classname"] as? String
                    event.date = eventDetails["Date"] as? String
                    event.syllabus = eventDetails["Syllabus"] as? String
                    event.time = eventDetails["Time"] as? String
                    event.title = eventDetails["Title"] as? String
                    if let weight = (eventDetails["Weight"] as! NSNumber) as Int? {
                        event.weight = weight
                    }
                    else {
                        event.weight = 0
                    }
                    if let description = eventDetails["Description"] as? String {
                        event.eventDescription = description
                    }
                    else {
                        event.eventDescription = "no description"
                    }
                    event.UUID = event.className!+event.date!+event.title!
                    
                    var flag = false
                    for each in eventsArray {
                        if each.UUID == event.UUID {
                            flag = true
                        }
                    }
                    if !flag {
                        eventsArray.append(event)
                    }
                }
            }
        }
        countUniqueClasses(sender)
    }
    
    func countUniqueClasses(sender: AnyObject) {
        for each in eventsArray {
            var duplicateFlag = false
            for classNames in uniqueClasses {
                if each.className?.lowercaseString == classNames.lowercaseString {
                    duplicateFlag = true
                    continue
                }
            }
            if !duplicateFlag {
                uniqueClasses.append(each.className!)
            }
        }
        
        for var i = 0; i < uniqueClasses.count; i++ {
            var count = 0
            eventSectionCount.append(0)
            for each in eventsArray {
                if each.className?.lowercaseString == uniqueClasses[i].lowercaseString {
                    count++
                }
            }
            eventSectionCount[i] = count
        }
        sortEventsArray(sender)
    }
    
    func sortEventsArray(sender:AnyObject) {
        var sortedEventsArray = [Event]()
        var prevEvent:Event?
        
        for var i = 0; i < uniqueClasses.count; i++ {
            for each in eventsArray {
                if each.className!.lowercaseString == uniqueClasses[i].lowercaseString && each.UUID != prevEvent?.UUID {
                    sortedEventsArray.append(each)
                    prevEvent = each
                }
            }
        }
        
        eventsArray = sortedEventsArray
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            self.scheduleNotification()
        }
        finish(sender)
    }
    
    func scheduleNotification() {
        let twoWeekNotification = UILocalNotification()
        let oneWeekNotification = UILocalNotification()
        let dayBeforeNotification = UILocalNotification()
        for each in eventsArray {
            if UserSettings.sharedInstance.notificationsScheduled[each.UUID!] == nil {
                
                let eventFireDateString = each.date
                var dateFromString = eventFireDateString!.componentsSeparatedByString("/")
                if dateFromString[2].length == 2 {
                    let twoThousandAndString = "20"
                    dateFromString[2] = twoThousandAndString+dateFromString[2]
                    each.date = "\(dateFromString[0])/\(dateFromString[1])/\(dateFromString[2])"
                }
                
                let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
                let finalDate = newCVDate.convertedDate()?.addHours(5)
                
                //check to make sure date isn't passed if it is don't schedule notifications
                let currentDate = NSDate()
                let todayCVDate = CVDate(date: currentDate)
                
                if each.weight >= 20 {
                    if todayCVDate.convertedDate()?.timeIntervalSince1970 < finalDate!.addDays(-15).timeIntervalSince1970 {
                        //two week prior notification
                        twoWeekNotification.userInfo = ["UUID": each.UUID!]
                        twoWeekNotification.fireDate = finalDate!.addDays(-14)
                        //print("two week notification fire date \(twoWeekNotification.fireDate)")
                        twoWeekNotification.timeZone = NSTimeZone.localTimeZone()
                        twoWeekNotification.alertBody = "You have \(each.title!) in class: \(each.className!) in two weeks"
                        twoWeekNotification.soundName = UILocalNotificationDefaultSoundName
                        UIApplication.sharedApplication().scheduleLocalNotification(twoWeekNotification)
                    }
                }
                
                if each.weight >= 5 {
                    if todayCVDate.convertedDate()?.timeIntervalSince1970 < finalDate!.addDays(-8).timeIntervalSince1970 {
                        
                        //one week prior notification
                        oneWeekNotification.userInfo = ["UUID": each.UUID!]
                        oneWeekNotification.fireDate = finalDate!.addDays(-7)
                        oneWeekNotification.timeZone = NSTimeZone.localTimeZone()
                        //print("one week notification fire date \(oneWeekNotification.fireDate)")
                        oneWeekNotification.alertBody = "Only one week until \(each.title!) for class: \(each.className!)"
                        oneWeekNotification.soundName = UILocalNotificationDefaultSoundName
                        UIApplication.sharedApplication().scheduleLocalNotification(oneWeekNotification)
                    }
                }
                
                //one day prior notification
                if todayCVDate.convertedDate()?.timeIntervalSince1970 < finalDate!.addDays(-2).timeIntervalSince1970 {
                    dayBeforeNotification.userInfo = ["UUID": each.UUID!]
                    dayBeforeNotification.fireDate = finalDate!.addDays(-1)
                    dayBeforeNotification.timeZone = NSTimeZone.localTimeZone()
                    //print("day before notification fire date \(dayBeforeNotification.fireDate)")
                    dayBeforeNotification.alertBody = "You have \(each.title!) in \(each.className!) tomorrow"
                    dayBeforeNotification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(dayBeforeNotification)
                }
                
                UserSettings.sharedInstance.notificationsScheduled[each.UUID!] = true
            }
            notificationsScheduled[each.UUID!] = true
        }
        checkNoRepeatNotifications()
    }
    
    func finish(sender: AnyObject) {
        
        if deletion {
            deletion = false
            if sender is CalendarController {
                let mySender = sender as! CalendarController
                mySender.finishLoading("deletion")
            }
        }
        if sender is CalendarController {
            let mySender = sender as! CalendarController
            mySender.finishLoading("addition")
        }
        if sender is EventsContainerController  {
            let mySender = sender as! EventsContainerController
            mySender.finishedLoading()
        }
        if sender is EventsController {
            let mySender = sender as! EventsController
            mySender.finishedLoading()
        }
    }
    
    func checkNoRepeatNotifications() {
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            var flag = false
            for each in UserSettings.sharedInstance.notificationsScheduled {
                if notification.userInfo!["UUID"] as! String == each.0 {
                    flag = true
                }
            }
            if !flag {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    func clearAll() {
        self.userEventsFromParse?.removeAllObjects()
        self.eventsTodayFromParse?.removeAllObjects()
        self.eventsArray.removeAll()
        self.eventsTodayArray.removeAll()
        self.uniqueClasses.removeAll()
        self.eventSectionCount.removeAll()
        UserSettings.sharedInstance.notificationsScheduled.removeAll()
        UIApplication.sharedApplication().scheduledLocalNotifications?.removeAll()
    }
    
    
    
    
    
    //Everything following is for pulling generic events for the events happening today
    
    
    
    
    func getEventsToday(sender: AnyObject) {
        let now = NSDate()
        let year = now.year
        let month = now.month
        let day = now.days
        
        let stringDate = "\(month)/\(day)/\(year)"
        
        let query:PFQuery = PFQuery(className: "groupEvents")
        query.whereKey("date", equalTo: stringDate)
        
        query.whereKey("region", equalTo: UserSettings.sharedInstance.locationRegion)
        
        
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                
                if let objects = objects as? [PFObject!] {
                    
                    self.eventsTodayFromParse = NSMutableArray()
                    
                    self.eventsTodayFromParse!.addObjectsFromArray(objects)
                    
                    self.createEventsFromEventsTodayArray(sender)
                }
                else {
                    
                }
            }
            else {
                print("Error getting query for events today", error, error!.userInfo)
            }
        }
    }
    
    func createEventsFromEventsTodayArray(sender: AnyObject) {
        if eventsTodayFromParse != nil {
            for each in eventsTodayFromParse! {
                if let eventDetails:AnyObject = each["details"] {
                    let event = Event()
                    event.time = eventDetails["Time"] as? String
                    event.location = eventDetails["Location"] as? String
                    event.title = eventDetails["Title"] as? String
                    if let group = each["group"] {
                        event.group = group as? String
                    }
                    if let eventDescription = each["description"] {
                        event.eventDescription = eventDescription as? String
                    }
                    if let eventPrice = each["price"] {
                        event.price = eventPrice as? String
                    }
                    event.UUID = event.title! + event.time! + event.location!
                    
                    var flag = false
                    for each in eventsTodayArray {
                        if each.UUID == event.UUID {
                            flag = true
                        }
                    }
                    if !flag {
                        eventsTodayArray.append(event)
                    }
                }
            }
        }
        finishCurrentEvents(sender)
    }
    
    func finishCurrentEvents(sender: AnyObject) {
        if sender is CurrentEventsController {
            let mySender = sender as! CurrentEventsController
            mySender.finishedLoading()
        }
    }
}
