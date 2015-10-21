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
    
    var eventsArray:NSMutableArray?
    
    var eventsArrayTypes = [String]()
    var eventsArrayDates = [String]()
    var eventsArrayTimes = [String]()
    var eventsArrayTitles = [String]()
    var eventsArrayWeights = [Int]()
    var eventsArraySyllabus = [String]()
    var eventsArrayCount:Array<Int> = [0]
    var headerCount:Int = 0
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
                    
                    self.eventsArray = NSMutableArray()
                    
                    self.eventsArray!.addObjectsFromArray(objects)
                    
                    self.getHeaderCount(sender)
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
    
    
    //Gets the number of syllabi (or at least attempts to)
    func getHeaderCount(sender: AnyObject) {
        var prevSyllabus:AnyObject?
        
        headerCount = 0
        if eventsArray!.count == 0 {
            self.finish(sender)
        }
        if eventsArray != nil {
            if let event:AnyObject = eventsArray?[0] {
                if let eventDetails:AnyObject = event["events"] {
                    if let syllabus: AnyObject? = eventDetails["Syllabus"] {
                        prevSyllabus = syllabus
                        headerCount++
                    }
                }
            }
        }
        
        if eventsArray != nil {
            print("eventsArray count: \(eventsArray!.count)")
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[i] {
                    if let eventDetails:AnyObject = event["events"] {
                        if let syllabus: AnyObject = eventDetails["Syllabus"] {
                            if syllabus.isEqual(prevSyllabus) {
                                continue
                            }
                            else {
                                eventsArraySyllabus.append("\(syllabus)")
                                headerCount++
                                prevSyllabus = syllabus
                            }
                        }
                    }
                }
            }
        }
        createEventsArray(sender)
    }
    
    
    
    func createEventsArray(sender: AnyObject) {
        if headerCount != eventsArrayCount.count {
            for var i = 0; i < headerCount; i++ { // used to be i=1 start... trying to fix issue
                eventsArrayCount.append(0)
            }
            getEventsPerHeader(sender)
        }
        finish(sender)
    }
    
    func getEventsPerHeader(sender: AnyObject) {
        var firstSyllabus:AnyObject?
        var prevSyllabus:AnyObject?
        
        var tmpHeaderCount = 0
        if eventsArray != nil {
            if let event:AnyObject = eventsArray?[0] {
                if let eventDetails:AnyObject = event["events"] {
                    if let syllabus: AnyObject? = eventDetails["Syllabus"] {
                        firstSyllabus = syllabus
                        prevSyllabus = firstSyllabus
                    }
                }
            }
        }
        
        if eventsArray != nil {
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[i] {
                    if let eventDetails:AnyObject = event["events"] {
                        if let syllabus: AnyObject = eventDetails["Syllabus"] {
                            if syllabus.isEqual(prevSyllabus) {
                                eventsArrayCount[tmpHeaderCount]++
                                
                                if let eventType:AnyObject = eventDetails["Type"] {
                                    eventsArrayTypes.append("\(eventType)")
                                }
                                if let eventDate:AnyObject = eventDetails["Date"] {
                                    eventsArrayDates.append("\(eventDate)")
                                }
                                if let eventTime:AnyObject = eventDetails["Time"] {
                                    eventsArrayTimes.append("\(eventTime)")
                                }
                                if let eventTitle:AnyObject = eventDetails["Title"] {
                                    eventsArrayTitles.append("\(eventTitle)")
                                }
                                if let eventWeight:AnyObject = eventDetails["Weight"] {
                                    eventsArrayWeights.append(eventWeight as! Int)
                                }
                                if let eventSyllabus:AnyObject = eventDetails["Syllabus"] {
                                    eventsArraySyllabus.append("\(eventSyllabus)")
                                }
                                
                                //schedule notifications
                                scheduleNotification(eventDetails)
                                
                                continue
                            }
                            else {
                                tmpHeaderCount++
                                eventsArrayCount[tmpHeaderCount]++
                                prevSyllabus = syllabus
                                
                                if let eventType:AnyObject = eventDetails["Type"] {
                                    eventsArrayTypes.append("\(eventType)")
                                }
                                if let eventDate:AnyObject = eventDetails["Date"] {
                                    eventsArrayDates.append("\(eventDate)")
                                }
                                if let eventTime:AnyObject = eventDetails["Time"] {
                                    eventsArrayTimes.append("\(eventTime)")
                                }
                                if let eventTitle:AnyObject = eventDetails["Title"] {
                                    eventsArrayTitles.append("\(eventTitle)")
                                }
                                if let eventWeight:AnyObject = eventDetails["Weight"] {
                                    eventsArrayWeights.append(eventWeight as! Int)
                                }
                                if let eventSyllabus:AnyObject = eventDetails["Syllabus"] {
                                    eventsArraySyllabus.append("\(eventSyllabus)")
                                }
                                
                                //schedule notifications
                                scheduleNotification(eventDetails)
                            }
                        }
                    }
                }
            }
        }
        finish(sender)
    }
    
    
    func scheduleNotification(eventDetails: AnyObject) {
        let twoWeekNotification = UILocalNotification()
        let oneWeekNotification = UILocalNotification()
        let dayBeforeNotification = UILocalNotification()
        let eventTitle:AnyObject? = eventDetails["Title"]
        let eventSyllabus:AnyObject? = eventDetails["Syllabus"]
        if let eventFireDate:AnyObject = eventDetails["Date"] {
            if UserSettings.sharedInstance.notificationsScheduled["\(eventTitle!)\(eventSyllabus)\(eventFireDate)"] == nil {
                let notificationUUID = "\(eventTitle!)\(eventSyllabus)\(eventFireDate)"
                
                let eventFireDateString = "\(eventFireDate)"
                let dateFromString = eventFireDateString.componentsSeparatedByString("/")
                let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
                let finalDate = newCVDate.convertedDate()?.addHours(5)
                
                //two week prior notification
                twoWeekNotification.userInfo = ["UUID": notificationUUID]
                twoWeekNotification.fireDate = finalDate!.addDays(-14)
                twoWeekNotification.timeZone = NSTimeZone.localTimeZone()
                twoWeekNotification.alertBody = "Don't forget! You have \(eventTitle!) in just two weeks!"
                twoWeekNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(twoWeekNotification)
                
                //one week prior notification
                oneWeekNotification.userInfo = ["UUID": notificationUUID]
                oneWeekNotification.fireDate = finalDate!.addDays(-7)
                oneWeekNotification.timeZone = NSTimeZone.localTimeZone()
                oneWeekNotification.alertBody = "Oh boy... Only one week until \(eventTitle!). You can do it!"
                oneWeekNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(oneWeekNotification)
                
                //one day prior notification
                dayBeforeNotification.userInfo = ["UUID": notificationUUID]
                dayBeforeNotification.fireDate = finalDate!.addDays(-1)
                dayBeforeNotification.timeZone = NSTimeZone.localTimeZone()
                dayBeforeNotification.alertBody = "Tomorrow is the day for \(eventTitle!). Don't forget and good luck!"
                dayBeforeNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(dayBeforeNotification)
                
                UserSettings.sharedInstance.notificationsScheduled["\(eventTitle!)\(eventSyllabus)\(eventFireDate)"] = true
            }
            notificationsScheduled["\(eventTitle)\(eventSyllabus)\(eventFireDate)"] == true
            //TODO use user settings that were just implemented to set the notifications that were set so that we don't set them more than once
            print("notifications: \n\(UserSettings.sharedInstance.notificationsScheduled)", terminator: "")
        }
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
        //TODO iterate through the local class level notifications list and the user settings notifications list and remove any repeats and remove any that are no longer there.

        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            var flag = false
            for each in UserSettings.sharedInstance.notificationsScheduled {
                if notification.userInfo!["UUID"] as! String == each.0 {
                    flag = true
                }
                if !flag {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
        }
        print("\n\n\n User Settings\(UserSettings.sharedInstance.notificationsScheduled)\n\n")
        print("UIApplication notifications \(UIApplication.sharedApplication().scheduledLocalNotifications)\n\n")

        //TODO check if there are repeat notifications scheduled. there shouldn't be but could possibly be...
        
//        for each in UserSettings.sharedInstance.notificationsScheduled {
//            if each == previousNotification! {
//                UserSettings.sharedInstance.notificationsScheduled.removeAtIndex(each.0, each.1)
//            }
//        }
    }
}
