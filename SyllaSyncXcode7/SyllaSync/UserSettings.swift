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
                PFPush.subscribeToChannelInBackground("BarEvents") { (succeeded, error) in
                    if succeeded {
                        print("ParseStarterProject successfully subscribed to push notifications on the barEvents channel.");
                    } else {
                        print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
                    }
                }
            }
            else {
                PFPush.unsubscribeFromChannelInBackground("BarEvents") {
                    (succeeded, error) in
                    if succeeded {
                        print("ParseStarterProject successfully unsubscribed to push notifications on the barEvents channel.");
                    } else {
                        print("ParseStarterProject failed to unsubscribe to push notifications on the barEvents channel with error = %@.", error)
                    }
                }
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
            if newSportEvents == true {
                PFPush.subscribeToChannelInBackground("SportEvents") { (succeeded, error) in
                    if succeeded {
                        print("ParseStarterProject successfully subscribed to push notifications on the sportEvents channel.");
                    } else {
                        print("ParseStarterProject failed to subscribe to push notifications on the sportEvents channel with error = %@.", error)
                    }
                }
            }
            else {
                PFPush.unsubscribeFromChannelInBackground("SportEvents") {
                    (succeeded, error) in
                    if succeeded {
                        print("ParseStarterProject successfully unsubscribed to push notifications on the sportEvents channel.");
                    } else {
                        print("ParseStarterProject failed to unsubscribe to push notifications on the sportEvents channel with error = %@.", error)
                    }
                }
            }
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
