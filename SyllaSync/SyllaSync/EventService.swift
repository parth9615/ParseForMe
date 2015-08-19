//
//  EventService.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import SwiftyJSON

private let EventServiceInstance = EventService()

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
    var json:JSON?
    public class var sharedInstance : EventService {
        return EventServiceInstance
    }
    
    func getJSON(sender: AnyObject) {
        
        var query:PFQuery = PFQuery(className: "Events")
        query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                println("got a query for \(UserSettings.sharedInstance.Username)")
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
                println("Error", error, error!.userInfo!)
            }
        }
    }
    
    func getHeaderCount(sender: AnyObject) {
        var prevSyllabus:AnyObject?
        
        var tmpHeaderCount = 0
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
            println("eventsArray count: \(eventsArray!.count)")
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
        println(headerCount)
        createEventsArray(sender)
    }
    
    func createEventsArray(sender: AnyObject) {
        if headerCount != eventsArrayCount.count {
            for var i = 1; i < headerCount; i++ {
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
                                scheduleNotifications(eventDetails)
                                
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
                                scheduleNotifications(eventDetails)
                            }
                        }
                    }
                }
            }
        }
        finish(sender)
    }
    
    
    func scheduleNotifications(eventDetails: AnyObject) {
        var twoWeekNotification = UILocalNotification()
        var oneWeekNotification = UILocalNotification()
        var dayBeforeNotification = UILocalNotification()
        if let eventFireDate:AnyObject = eventDetails["Date"] {
            var eventFireDateString = "\(eventFireDate)"
            let dateFromString = eventFireDateString.componentsSeparatedByString("/")
            var newCVDate = CVDate(day: dateFromString[1].toInt()!, month: dateFromString[0].toInt()!, week: ((dateFromString[1].toInt()!)/7)+1, year: dateFromString[2].toInt()!)
            
            //two week prior notification
            twoWeekNotification.fireDate = newCVDate.convertedDate()
            twoWeekNotification.timeZone = NSTimeZone.localTimeZone()
            
            
        }
    }
    
    func finish(sender: AnyObject) {
        if sender is EventsContainerController  {
            var mySender = sender as! EventsContainerController
            mySender.finishedLoading()
        }
        if sender is EventsController {
            var mySender = sender as! EventsController
            mySender.finishedLoading()
        }
    }
}
