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
    var eventService = EventService.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var headerCount = eventService.headerCount
        println("headerCount \(headerCount)")
        return headerCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var eventsArrayCount = eventService.eventsArrayCount
        println("section: \(section)")
        println("eventsArrayCount: \(eventsArrayCount)")
        return eventsArrayCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
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
        
        var syllabusArray = eventService.eventsArraySyllabus
        println(section)
        label.text = syllabusArray[section]
        
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
