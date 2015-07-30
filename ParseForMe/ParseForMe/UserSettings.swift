//
//  UserSettings.swift
//  ParseForMe
//
//  Created by Joel Wasserman on 7/30/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation

private let _UserSettings = UserSettings()

public class UserSettings {
    
    struct Constants {
        static let Username = "Username"
        static let SyllabusArray = "SyllabusArray"
        static let EventsArray = "EventsArray"
    }
    
    public class var sharedInstance: UserSettings {
        return _UserSettings
    }
    
    public var Username:String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Constants.Username)
        }
        set (newUsername) {
            NSUserDefaults.standardUserDefaults().setObject(newUsername, forKey: Constants.Username)
        }
    }
    
//    public var SyllabusArray:Array<AnyObject>? {
//        get {
//            return NSUserDefaults.standardUserDefaults().arrayForKey(Constants.SyllabusArray)
//        }
//        set (newSyllabusArray) {
//            NSUserDefaults.standardUserDefaults().setObject(newSyllabusArray, forKey: Constants.SyllabusArray)
//        }
//    }
//    
//    public var EventsArray:NSData? {
//        get {
//            return NSUserDefaults.standardUserDefaults().objectForKey(Constants.EventsArray) as? NSData
//        }
//        set (newEventsArray) {
//            NSUserDefaults.standardUserDefaults().setObject(newEventsArray, forKey: Constants.EventsArray)
//        }
//    }
}