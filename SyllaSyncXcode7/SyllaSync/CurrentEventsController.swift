//
//  SettingsController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation




//http://stackoverflow.com/questions/24899257/how-to-setup-push-notifications-in-swift



//turn off and on push notifications for reminders 
//also customize what you want notifications for - whether you want office hours and stuff like that
//this might need to be a table view controller



class CurrentEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    var eventService = EventService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        let alert = UIAlertController(title: "We're Sorry", message: "There are no settings available at this time", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        alert.addAction(OKAction)
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventService.eventsTodayArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        
//        let indexPathSection = indexPath.section
//        previousClasses = 0
//        for var i = indexPathSection-1; i >= 0; i-- {
//            previousClasses += eventService.eventSectionCount[i]
//        }
        //cell?.backgroundColor = UIColor(rgba: "#04a4ca")//.colorWithAlphaComponent(0.2)
        cell?.eventName.text = eventService.eventsArray[indexPath.row + previousClasses].title
        cell?.eventTime.text = eventService.eventsArray[indexPath.row + previousClasses].time
        cell?.eventDate.text = eventService.eventsArray[indexPath.row + previousClasses].date
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
