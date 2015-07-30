//
//  CalendarController.swift
//  ParseForMe
//
//  Created by Joel Wasserman on 7/28/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class CalendarController: UIViewController {

    var itemIndex:Int = 1
    var eventsArray:NSMutableArray?
    @IBOutlet weak var navBar: UINavigationBar!
    var delegate: EventsContainerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.frame = CGRectMake(0, 0, self.view.frame.width, 70)
        
        println(self.eventsArray)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hamburgerPressed(sender: AnyObject) {
        delegate?.toggleLeftPanel?(self)
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
