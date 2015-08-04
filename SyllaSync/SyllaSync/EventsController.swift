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
    var headerCount:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(self.eventsArray)
        
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
                            headerCount++
                            prevSyllabus = syllabus
                        }
                    }
                }
            }
        }
        
        println("\n\n\n\n\(headerCount)\n\n\n")
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
        return 0
    }
    
    //For Hamburger Settings
    @IBAction func hamburgerPressed(sender: AnyObject) {
        delegate?.toggleLeftPanel?(self)
    }

    

}
