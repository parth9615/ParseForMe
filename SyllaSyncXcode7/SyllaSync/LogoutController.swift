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

    @IBOutlet weak var logoutButton: shadowedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontSize = logoutButton.titleLabel!.font.pointSize
        logoutButton.titleLabel?.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        EventService.sharedInstance.clearAll()
        
        #if FREE
            let loginStoryBoard = UIStoryboard(name: "MainFree", bundle: nil)
            let loginVC = loginStoryBoard.instantiateViewControllerWithIdentifier("Login") as! LoginController
            self.presentViewController(loginVC, animated: true, completion: nil)
        #else
            let loginStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = loginStoryBoard.instantiateViewControllerWithIdentifier("Login") as! LoginController
            self.presentViewController(loginVC, animated: true, completion: nil)
        #endif
        
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
