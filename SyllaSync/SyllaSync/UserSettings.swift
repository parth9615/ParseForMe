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
    
}
