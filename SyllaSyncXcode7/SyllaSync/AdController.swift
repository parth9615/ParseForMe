//
//  AdController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 12/31/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class AdController: UIViewController {
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("ad view did appear")
        count++
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:  "proceed", userInfo:  nil, repeats: false)
        
        
        if count == 2 {
            proceed()
        }
    }
    
    func proceed() {
        let parseVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParseLoginController") as! ParseLoginController
        self.presentViewController(parseVC, animated: true, completion: nil)
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

}
