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
    var syllabusArray:Array<String> = []
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
                    syllabusArray.append("\(syllabus)")
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
                            syllabusArray.append("\(syllabus)")
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
                if let syllabus:AnyObject? = event["syllabus"] {
                    firstSyllabus = syllabus
                    prevSyllabus = firstSyllabus
                }
            }
        }
        
        if eventsArray != nil {
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[0] {
                    if let syllabus: AnyObject? = event["syllabus"] {
                        if syllabus!.isEqual(prevSyllabus) {
                            eventsArrayCount[tmpHeaderCount]++
                            
                            //will be used once we figured out the JSON format
                            
                            //                            if let eventDetails: AnyObject? = event["events"] {
                            //                                eventsArrayNames = eventDetails[1]
                            //                            }
                            //                            if let eventDetails: AnyObject? = event["events"] {
                            //                                eventsArrayDates = eventDetails[0]
                            //                            }
                            
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
