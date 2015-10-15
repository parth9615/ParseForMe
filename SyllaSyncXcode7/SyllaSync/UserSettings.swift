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
        static let SportEvents = "SportEvents"
        static let BarEvents = "BarEvents"
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
            if NSUserDefaults.standardUserDefaults().dictionaryForKey(Constants.notificationsScheduled) == nil {
                return [:]
                //return new dictionary object
            }
            else {
                return NSUserDefaults.standardUserDefaults().dictionaryForKey(Constants.notificationsScheduled)!
            }
        }
        set (newNotificaionsScheduled) {
            NSUserDefaults.standardUserDefaults().setObject(newNotificaionsScheduled, forKey: Constants.notificationsScheduled)
        }
    }
    
    public var BarEvents:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.BarEvents) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.BarEvents) as? Bool
            }
        }
        set(newBarEvents) {
            
            if newBarEvents == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("BarEvents" forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("BarEvents" forKey: "channels")
                currentInstallation.saveInBackground()
            }
            NSUserDefaults.standardUserDefaults().setObject(newBarEvents, forKey: Constants.BarEvents)
        }
    }
    
    public var SportEvents:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.SportEvents) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.SportEvents) as? Bool
            }
        }
        set(newSportEvents) {
            NSUserDefaults.standardUserDefaults().setObject(newSportEvents, forKey: Constants.SportEvents)
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
