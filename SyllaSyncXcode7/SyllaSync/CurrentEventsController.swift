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

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    var eventService = EventService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        navBar.barTintColor = UIColor(rgba: "#04a4ca")
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventService.eventsTodayArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Event"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier) as? EventCell
        }
        print(indexPath.row)
        print(indexPath.section)
        let fontSize = cell!.eventName.font.pointSize
        cell?.eventName.text = eventService.eventsTodayArray[indexPath.row].title
        cell?.eventName.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        
        cell?.eventTime.text = eventService.eventsTodayArray[indexPath.row].time
        cell?.eventTime.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        
        cell?.eventLocation.text = "Where? \(eventService.eventsTodayArray[indexPath.row].location!)"
        cell?.eventLocation.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        
        cell?.eventDate.text = ""
        
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
