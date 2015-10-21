//
//  Event.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

public class Event: NSObject {
    
    public var type: String? {
        get {
            return self.type
        }
        set(newType) {
            self.type = newType
        }
    }
    
    public var date:String? {
        get {
            return self.date
        }
        set (newDate) {
            self.date = newDate
        }
    }

    public var time: String? {
        get {
            return self.time
        }
        set(newTime) {
            self.time = newTime
        }
    }
    
    public var title:String? {
        get {
            return self.title
        }
        set (newTitle) {
            self.title = newTitle
        }
    }

    public var weight: Int? {
        get {
            return self.weight
        }
        set(newWeight) {
            self.weight = newWeight
        }
    }
    
    public var syllabus:String? {
        get {
            return self.syllabus
        }
        set (newSyllabus) {
            self.syllabus = newSyllabus
        }
    }
    
    public var className:String? {
        get {
            return self.className
        }
        set (newClassName) {
            self.className = newClassName
        }
    }
}



