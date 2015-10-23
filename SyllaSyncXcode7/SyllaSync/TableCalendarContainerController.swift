//
//  TableCalendarContainerController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/9/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class TableCalendarContainerController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var delegate: EventsContainerControllerDelegate?
    @IBOutlet weak var navigationBar: UINavigationBar!
    var eventsController:EventsController?
    var calendarController:CalendarController?
    var calendarView = true
    var eventsView = false
    var eventViews:[String:UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor(rgba: "#04a4ca")
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if calendarController == nil {
            calendarController = self.storyboard?.instantiateViewControllerWithIdentifier("Calendar") as? CalendarController
        }
        addChildViewController(calendarController!)
        container.addSubview(calendarController!.view)       
        
        let imageView = UIImageView(frame: CGRectMake(self.navigationBar.frame.minX, self.navigationBar.frame.minY, self.navigationBar.frame.width/1.5, self.navigationBar.frame.height/1.5));
        let image = UIImage(named: "SyllaSyncWords")
        imageView.image = image
        navigationBar.topItem?.titleView?.frame = CGRectMake(self.view.frame.minX, self.view.frame.minY, self.view.frame.width/1.5, self.view.frame.height/1.5)
        navigationBar.topItem?.titleView = imageView
        navigationBar.topItem?.titleView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    
    func toggleViews() {
        if eventsView == true {
            eventsView = false
            calendarView = true
            
            if calendarController == nil {
                calendarController = self.storyboard?.instantiateViewControllerWithIdentifier("Calendar") as? CalendarController
            }
            
            container.addSubview(calendarController!.view)
        }
        else if eventsView == false {
            eventsView = true
            calendarView = false
            
            if eventsController == nil {
                eventsController = self.storyboard?.instantiateViewControllerWithIdentifier("Table") as? EventsController
            }
            
            container.addSubview(eventsController!.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func hamburgerPressed(sender: AnyObject) {
        delegate?.toggleLeftPanel?(self)
    }

    @IBAction func editPressed(sender: AnyObject) {
        
        let addEventVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddEventScrollController") as! AddEventScrollController
        self.presentViewController(addEventVC, animated: true, completion: nil)
        
//        let alert = UIAlertController(title: "Oh No!", message: "This feature is currently unavailable", preferredStyle: .Alert)
//        let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
//            
//        }
//        alert.addAction(OKAction)
//        self.presentViewController(alert, animated: true, completion: nil)
    }
}
