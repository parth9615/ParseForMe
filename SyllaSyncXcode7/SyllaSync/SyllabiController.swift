//
//  SyllabiController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/14/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class SyllabiController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var syllabiLabel: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var syllabiTable: UITableView!
    var eventService = EventService.sharedInstance
    var syllabiArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syllabiTable.delegate = self
        syllabiTable.dataSource = self
        
        syllabiLabel.titleView?.backgroundColor = UIColor(rgba: "#04a4ca")
        navigationBar.barTintColor = UIColor(rgba: "#04a4ca")
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        getSyllabiArray()
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        syllabiTable.addSubview(refreshControl)
        
    }
    
    func getSyllabiArray() {
        let syllabusArray = eventService.eventsArraySyllabus
        let syllabus = syllabusArray.first
        syllabiArray.append(syllabus!)
        for each in syllabusArray {
            if each == syllabus {
                continue
            }
            else {
                syllabiArray.append(each)
            }
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editSyllabi(sender: AnyObject) {
        //TODO add in functionality for a table view edit manually
    }
    
    func refresh() {
        eventService.getJSON(self)
        syllabiTable.reloadData()
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventService.headerCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Syllabi"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? SyllabiCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? SyllabiCell
        }
        
        cell?.syllabusTitleLabel.text = syllabiArray[indexPath.row]
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        let syllabus = syllabiArray[indexPath.row]
        let syllabusViewerVC = self.storyboard?.instantiateViewControllerWithIdentifier("SyllabusViewer") as? SyllabusViewerController
        syllabusViewerVC?.syllabusToDisplayString = syllabus
        self.presentViewController(syllabusViewerVC!, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
