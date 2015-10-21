//
//  EventService.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import CVCalendar

private let EventServiceInstance = EventService()

public struct EventServiceConstants {
    public static let EventAdded = "EventAdded"
    public static let EventDeleted = "EventDeleted"
}

public class EventService: NSObject {
    
    var eventsFromParse:NSMutableArray?
    var eventsArray = [Event]()
    
    var uniqueClassCount = 0
    var uniqueClasses = [String]()
    
    //    var json:JSON?
    public class var sharedInstance : EventService {
        return EventServiceInstance
    }
    var notificationsScheduled = [String:Bool]()
    
    func getJSON(sender: AnyObject) {
        UserSettings.sharedInstance.notificationsScheduled.removeAll()
        
        let query:PFQuery = PFQuery(className: "Events")
        query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                print("got a query for \(UserSettings.sharedInstance.Username)")
                if let objects = objects as? [PFObject!] {
                    
                    self.eventsFromParse = NSMutableArray()
                    
                    self.eventsFromParse!.addObjectsFromArray(objects)
                    
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
        if eventsFromParse != nil {
            for each in eventsFromParse! {
                if let eventDetails:AnyObject = each["events"] {
                    
                    let event = Event()
                    event.className = eventDetails["Classname"] as? String
                    event.date = eventDetails["Date"] as? String
                    event.syllabus = eventDetails["Syllabus"] as? String
                    event.time = eventDetails["Time"] as? String
                    event.title = eventDetails["Title"] as? String
                    event.weight = (eventDetails["Weight"] as! NSNumber) as Int
                    event.UUID = event.className!+event.date!+event.title!
                    
                    eventsArray.append(event)
                }
            }
        }
        countUniqueClasses(sender)
    }
    
    func countUniqueClasses(sender: AnyObject) {
        for each in eventsArray {
            var duplicateFlag = false
            for classNames in uniqueClasses {
                if each.className == classNames {
                    duplicateFlag = true
                    continue
                }
            }
            if !duplicateFlag {
                uniqueClasses.append(each.className!)
            }
        }
        scheduleNotification(sender)
    }
    
    func scheduleNotification(sender: AnyObject) {
        let twoWeekNotification = UILocalNotification()
        let oneWeekNotification = UILocalNotification()
        let dayBeforeNotification = UILocalNotification()
        for each in eventsArray {
            if UserSettings.sharedInstance.notificationsScheduled[each.UUID!] == nil {
                
                let eventFireDateString = each.date
                let dateFromString = eventFireDateString!.componentsSeparatedByString("/")
                let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
                let finalDate = newCVDate.convertedDate()?.addHours(5)
                
                //two week prior notification
                twoWeekNotification.userInfo = ["UUID": each.UUID!]
                twoWeekNotification.fireDate = finalDate!.addDays(-14)
                twoWeekNotification.timeZone = NSTimeZone.localTimeZone()
                twoWeekNotification.alertBody = "You have \(each.title!) in two weeks! Time to start studying!"
                twoWeekNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(twoWeekNotification)
                
                //one week prior notification
                oneWeekNotification.userInfo = ["UUID": each.UUID!]
                oneWeekNotification.fireDate = finalDate!.addDays(-7)
                oneWeekNotification.timeZone = NSTimeZone.localTimeZone()
                oneWeekNotification.alertBody = "Only one week until \(each.title!). Keep up the hard work!"
                oneWeekNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(oneWeekNotification)
                
                //one day prior notification
                dayBeforeNotification.userInfo = ["UUID": each.UUID!]
                dayBeforeNotification.fireDate = finalDate!.addDays(-1)
                dayBeforeNotification.timeZone = NSTimeZone.localTimeZone()
                dayBeforeNotification.alertBody = "You have \(each.title!) tomorrow. Good luck!"
                dayBeforeNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(dayBeforeNotification)
                
                UserSettings.sharedInstance.notificationsScheduled[each.UUID!] = true
            }
            notificationsScheduled[each.UUID!] == true
        }
        finish(sender)
    }
    
    func finish(sender: AnyObject) {
        
        checkNoRepeatNotifications()
        if sender is CalendarController {
            let mySender = sender as! CalendarController
            mySender.finishLoading()
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
        print("\n\n\n User Settings\(UserSettings.sharedInstance.notificationsScheduled)\n\n")
        print("UIApplication notifications \(UIApplication.sharedApplication().scheduledLocalNotifications)\n\n")
    }
}
