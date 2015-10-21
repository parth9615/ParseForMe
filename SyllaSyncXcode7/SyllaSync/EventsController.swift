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
    
    var eventSectionCount = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        for var i = 0; i < eventService.uniqueClasses.count; i++ {
            eventSectionCount.append(0)
        }
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventService.uniqueClasses.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        for each in eventService.eventsArray {
            if each.className == eventService.uniqueClasses[section] {
                count++
            }
        }
        print(section)
        eventSectionCount[section] = count
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        
        let indexPathSection = indexPath.section
        previousClasses = 0
        for var i = indexPathSection-1; i >= 0; i-- {
            previousClasses += eventSectionCount[i]
        }
        //cell?.backgroundColor = UIColor(rgba: "#04a4ca")//.colorWithAlphaComponent(0.2)
        cell?.eventName.text = eventService.eventsArray[indexPath.row + previousClasses].title
        cell?.eventTime.text = eventService.eventsArray[indexPath.row + previousClasses].time
        cell?.eventDate.text = eventService.eventsArray[indexPath.row + previousClasses].date
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width/1.5, 20))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.center = CGPoint(x: self.view.bounds.size.width/2, y:11)
        label.layer.borderColor = UIColor.lightGrayColor().CGColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        
        label.font = UIFont(name: "BoosterNextFY-Black", size: 15)
        
        label.text = eventService.uniqueClasses[section]
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(label)
        return view
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {

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
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
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
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
