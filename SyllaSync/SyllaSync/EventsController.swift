//
//  EventsController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

@objc
public protocol EventsContainerControllerDelegate {
    optional func toggleLeftPanel(sender: AnyObject)
    optional func collapseSidePanels()
}

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var eventsTable: UITableView!
    var itemIndex: Int = 1

    var previousClasses:Int = 0
    var refreshControl:UIRefreshControl!
    var eventService = EventService.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self

        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        eventsTable.addSubview(refreshControl)
  
    }
    
    func refresh() {
        eventService.getJSON(self)
        eventsTable.reloadData()
    }
    
    func finishedLoading() {
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var headerCount = eventService.headerCount
        return headerCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var eventsArrayCount = eventService.eventsArrayCount
        return eventsArrayCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        
        var indexPathSection = indexPath.section
        previousClasses = 0
        for var i = indexPathSection-1; i >= 0; i-- {
            previousClasses += eventService.eventsArrayCount[i]
        }
        //cell?.backgroundColor = UIColor(rgba: "#04a4ca")//.colorWithAlphaComponent(0.2)
        cell?.eventName.text = eventService.eventsArrayTitles[indexPath.row + previousClasses]
        cell?.eventTime.text = eventService.eventsArrayTimes[indexPath.row + previousClasses]
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = UILabel(frame: CGRectMake(-1, 0, self.view.bounds.size.width+2, 24))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.layer.borderColor = UIColor.lightGrayColor().CGColor
        label.layer.borderWidth = 1
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        
        label.font = UIFont(name: "BoosterNextFY-Black", size: 15)
        
        var classNameArray = eventService.eventsArraySyllabus
        label.text = classNameArray[section]
        
        var view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(label)
        return view
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return NO if you do not want the specified item to be editable.
    //        return false
    //    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        //        if indexPath.row == HamburgerCells.Settings.rawValue {
        //            //go to new page
        //
        //        }
        //        else if indexPath.row == HamburgerCells.AboutUs.rawValue {
        //            //go to new page
        //
        //        }
        //        else if indexPath.row == HamburgerCells.Compare.rawValue {
        //
        //
        //        }
        //        else if indexPath.row == HamburgerCells.Invite.rawValue {
        //
        //
        //        }
        //        else {
        //
        //
        //        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UIColor {
    public convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (count(hex)) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                println("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
