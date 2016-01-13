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
        static let RelayForLife = "RelayForLife"
        static let ACappella = "ACappella"
        static let MemorialHall = "MemorialHall"
        static let BlackStudentMovement = "BlackStudentMovement"
        static let CUAB = "CUAB"
        static let FreeFood = "FreeFood"
        static let CampusY = "CampusY"
        static let ClubSports = "ClubSports"
        static let BarEvents = "BarEvents"
        static let CAA = "CAA"
        static let Username = "Username"
        static let SyllabusArray = "SyllabusArray"
        static let EventsArray = "EventsArray"
        static let notificationsScheduled = "notificationsScheduled"
        static let locationRegion = "locationRegion"
    }
    
    public class var sharedInstance: UserSettings {
        return _UserSettings
    }
    
    public var locationRegion:String {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.locationRegion) == nil {
                return "undefined"
                //return new dictionary object
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.locationRegion) as! String
            }
        }
        set (newLocationRegion) {
            NSUserDefaults.standardUserDefaults().setObject(newLocationRegion, forKey: Constants.locationRegion)
        }
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
    
    public var RelayForLife:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.RelayForLife) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.RelayForLife) as? Bool
            }
        }
        set(newRelayForLife) {
            if newRelayForLife == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("RelayForLife", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("RelayForLife", forKey: "channels")
                currentInstallation.saveInBackground()            }
                NSUserDefaults.standardUserDefaults().setObject(newRelayForLife, forKey: Constants.RelayForLife)
        }
    }
    
    public var ACappella:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.ACappella) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.ACappella) as? Bool
            }
        }
        set(newACappella) {
            if newACappella == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("ACappella", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("ACappella", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newACappella, forKey: Constants.ACappella)
        }
    }
    
    public var MemorialHall:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.MemorialHall) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.MemorialHall) as? Bool
            }
        }
        set(newMemorialHall) {
            if newMemorialHall == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("MemorialHall", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("MemorialHall", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newMemorialHall, forKey: Constants.MemorialHall)
        }
    }
    
    public var BlackStudentMovement:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.BlackStudentMovement) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.BlackStudentMovement) as? Bool
            }
        }
        set(newBlackStudentMovement) {
            if newBlackStudentMovement == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("BlackStudentMovement", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("BlackStudentMovement", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newBlackStudentMovement, forKey: Constants.BlackStudentMovement)
        }
    }
    
    public var CUAB:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.CUAB) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.CUAB) as? Bool
            }
        }
        set(newCUAB) {
            if newCUAB == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("CUAB", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("CUAB", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newCUAB, forKey: Constants.CUAB)
        }
    }
    
    public var FreeFood:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.FreeFood) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.FreeFood) as? Bool
            }
        }
        set(newFreeFood) {
            if newFreeFood == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("FreeFood", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("FreeFood", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newFreeFood, forKey: Constants.FreeFood)
        }
    }
    
    public var CampusY:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.CampusY) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.CampusY) as? Bool
            }
        }
        set(newCampusY) {
            if newCampusY == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("CampusY", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("CampusY", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(CampusY, forKey: Constants.CampusY)
        }
    }
    
    public var ClubSports:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.ClubSports) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.ClubSports) as? Bool
            }
        }
        set(newClubSports) {
            if newClubSports == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("ClubSports", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("ClubSports", forKey: "channels")
                currentInstallation.saveInBackground()            }
            NSUserDefaults.standardUserDefaults().setObject(newClubSports, forKey: Constants.ClubSports)
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
                currentInstallation.addUniqueObject("BarEvents", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("BarEvents", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            NSUserDefaults.standardUserDefaults().setObject(newBarEvents, forKey: Constants.BarEvents)
        }
    }
    
    public var CAA:Bool? {
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey(Constants.CAA) == nil {
                return true
            }
            else {
                return NSUserDefaults.standardUserDefaults().objectForKey(Constants.CAA) as? Bool
            }
        }
        set(newCAA) {
            if newCAA == true {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("CAA", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            else {
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.removeObject("CAA", forKey: "channels")
                currentInstallation.saveInBackground()
            }
            NSUserDefaults.standardUserDefaults().setObject(newCAA, forKey: Constants.CAA)
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
