//
//  Event.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

public class Event: NSObject {
    
    public var type:String?
    public var date:NSDate?
    public var time:String?
    public var title:String?
    public var weight:Int?
    public var syllabus:String?
    
    
    public var eventType: String? {
        get {
            return type
        }
        set(newType) {
            type = newType
        }
    }
    
    public var eventDate:NSDate? {
        get {
            return date
        }
        set (newDate) {
            date = newDate
        }
    }

    public var eventTime: String? {
        get {
            return time
        }
        set(newTime) {
            time = newTime
        }
    }
    
    public var eventTitle:String? {
        get {
            return title
        }
        set (newTitle) {
            title = newTitle
        }
    }

    public var eventWeight: Int? {
        get {
            return weight
        }
        set(newWeight) {
            weight = newWeight
        }
    }
    
    public var eventSyllabus:String? {
        get {
            return syllabus
        }
        set (newSyllabus) {
            syllabus = newSyllabus
        }
    }
}



