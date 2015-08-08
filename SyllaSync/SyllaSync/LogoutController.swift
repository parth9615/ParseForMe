//
//  LogoutController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/7/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import Parse

class LogoutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        var loginStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        var loginVC = loginStoryBoard.instantiateViewControllerWithIdentifier("Login") as! LoginController
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func close(sender: AnyObject) {
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
