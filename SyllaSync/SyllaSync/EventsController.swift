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

class EventsController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var eventsTable: UITableView!
    var itemIndex: Int = 1
    var delegate: EventsContainerControllerDelegate?
    var eventsArray:NSMutableArray?
    var eventsArrayCount:Array<Int> = [0]
    var syllabusArray:Array<String> = []
    var headerCount:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHeaderCount()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getHeaderCount() {
        var prevSyllabus:AnyObject?
        if eventsArray != nil {
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[0] {
                    if let syllabus: AnyObject? = event["syllabus"] {
                        if syllabus!.isEqual(prevSyllabus) {
                            continue
                        }
                        else {
                            syllabusArray.append("\(syllabus)")
                            headerCount++
                            prevSyllabus = syllabus
                        }
                    }
                }
            }
        }
        
        println("\n\n\n\n\(headerCount)\n\n\n")
        
        createEventsArray()
    }
    
    func createEventsArray() {
        for var i = 1; i < headerCount; i++ {
            eventsArrayCount.append(0)
        }
        getEventsPerHeader()
    }
    
    func getEventsPerHeader() {
        var prevSyllabus:AnyObject?
        var tmpHeaderCount = 0
        if eventsArray != nil {
            for var i = 0; i < eventsArray!.count; i++ {
                if let event: AnyObject = eventsArray?[0] {
                    if let syllabus: AnyObject? = event["syllabus"] {
                        if syllabus!.isEqual(prevSyllabus) {
                            eventsArrayCount[tmpHeaderCount]++
                            continue
                        }
                        else {
                            headerCount++
                            prevSyllabus = syllabus
                        }
                    }
                }
            }
        }
        
        println(eventsArrayCount)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return headerCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return eventsArrayCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.row == HamburgerCells.Filler.rawValue {
            var cellIdentifier = "Event"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
//        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = UILabel(frame: CGRectMake(-1, 0, self.view.bounds.size.width+2, 24))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.layer.borderColor = UIColor.lightGrayColor().CGColor
        label.layer.borderWidth = 1
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        
        label.text = syllabusArray[section]
//        if tableViewSectionsArray[section].dayString() == NSDate().dayString() {
//            label.text = "Today"
//        }
//        else {
//            label.text = "\(tableViewSectionsArray[section].dayString())"
//        }
        
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
    
    //For Hamburger Settings
    @IBAction func hamburgerPressed(sender: AnyObject) {
        delegate?.toggleLeftPanel?(self)
    }

    

}
