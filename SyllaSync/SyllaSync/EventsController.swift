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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var eventsTable: UITableView!
    var itemIndex: Int = 1
    var delegate: EventsContainerControllerDelegate?
    var previousClasses:Int = 0
    var eventService = EventService.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        

        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var imageView = UIImageView(frame: CGRectMake(self.navigationBar.frame.minX, self.navigationBar.frame.minY, self.navigationBar.frame.width, self.navigationBar.frame.height));
        var image = UIImage(named: "SyllaSyncWords")
        imageView.image = image
        navigationBar.topItem?.titleView?.frame = CGRectMake(self.view.frame.minX, self.view.frame.minY, self.view.frame.width, self.view.frame.height)
        println(navigationBar.topItem?.titleView?.frame)
        navigationBar.topItem?.titleView = imageView
        navigationBar.topItem?.titleView?.contentMode = UIViewContentMode.ScaleAspectFit
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
    
    @IBAction func hamburgerPressed(sender: AnyObject) {
        delegate?.toggleLeftPanel?(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}

extension CGColor {
    
    class func colorWithHex(hex: Int) -> CGColorRef {
        
        return UIColor(hex: hex).CGColor
        
    }
    
}
