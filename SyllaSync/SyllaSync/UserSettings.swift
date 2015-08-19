//
//  UserSettings.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation

private let _UserSettings = UserSettings()

public class UserSettings {
    
    struct Constants {
        static let Username = "Username"
        static let SyllabusArray = "SyllabusArray"
        static let EventsArray = "EventsArray"
        static let notificationsScheduled = "notificationsScheduled"
    }
    
    public class var sharedInstance: UserSettings {
        return _UserSettings
    }
    
    public var notificationsScheduled:[NSObject:AnyObject] { //[String:Bool]
        get {
            return NSUserDefaults.standardUserDefaults().dictionaryForKey(Constants.notificationsScheduled)!
        }
        set (newNotificaionsScheduled) {
            NSUserDefaults.standardUserDefaults().setObject(newNotificaionsScheduled, forKey: Constants.notificationsScheduled)
        }
    }
    
    public var Username:String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Constants.Username)
        }
        set (newUsername) {
            NSUserDefaults.standardUserDefaults().setObject(newUsername, forKey: Constants.Username)
        }
    }
    
}
