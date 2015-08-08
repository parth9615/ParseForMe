//
//  CalendarController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class CalendarController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var itemIndex:Int = 1
    var eventsArray:NSMutableArray?
    var delegate: EventsContainerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //println(self.eventsArray)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var imageView = UIImageView(frame: CGRectMake(self.navigationBar.frame.minX, self.navigationBar.frame.minY, self.navigationBar.frame.width, self.navigationBar.frame.height));
        var image = UIImage(named: "SyllaSyncWords")
        imageView.image = image
        navigationBar.topItem?.titleView?.frame = CGRectMake(self.view.frame.minX, self.view.frame.minY, self.view.frame.width, self.view.frame.height)
        navigationBar.topItem?.titleView = imageView
        navigationBar.topItem?.titleView?.contentMode = UIViewContentMode.ScaleAspectFit
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
