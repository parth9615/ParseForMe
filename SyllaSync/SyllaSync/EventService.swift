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
    
    func getJSON(sender: EventsContainerController) {
        
        var query:PFQuery = PFQuery(className: "Events")
        query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                println("got a query for \(UserSettings.sharedInstance.Username)")
                if let objects = objects as? [PFObject!] {
                    
                    self.eventsArray = NSMutableArray()
                    
                    self.eventsArray!.addObjectsFromArray(objects)
                    
                    self.getHeaderCount()
                    sender.removeDimView()
                }
            }
            else {
                println("Error", error, error!.userInfo!)
            }
        }
    }
    
    public func getHeaderCount() {
        var prevSyllabus:AnyObject?
        
        if eventsArray != nil {
            if let event:AnyObject = eventsArray?[0] {
                if let syllabus:AnyObject? = event["syllabus"] {
                    eventsArraySyllabus.append("\(syllabus)")
                    prevSyllabus = syllabus
                    headerCount++
                }
            }
        }
        
        if eventsArray != nil {
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[0] {
                    if let syllabus: AnyObject? = event["syllabus"] {
                        if syllabus!.isEqual(prevSyllabus) {
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
        createEventsArray()
    }
    
    func createEventsArray() {
        for var i = 1; i < headerCount; i++ {
            eventsArrayCount.append(0)
        }
        getEventsPerHeader()
    }
    
    func getEventsPerHeader() {
        var firstSyllabus:AnyObject?
        var prevSyllabus:AnyObject?
        
        var tmpHeaderCount = 0
        if eventsArray != nil {
            if let event:AnyObject = eventsArray?[0] {
                if let eventDetails:AnyObject = event["events"] {
                    if let syllabus: AnyObject? = eventDetails["syllabus"] {
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
                        if let syllabus: AnyObject = eventDetails["syllabus"] {
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
                            
                            continue
                        }
                        else {
                            headerCount++
                            prevSyllabus = syllabus
                        }
                    }
                }
            }
        }
        
        println(eventsArrayCount)
    }
    
}
}
