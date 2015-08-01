//
//  ViewController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var window: UIWindow?
    var req:FBSDKGraphRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
           // skipToChallenges()
        }
        else {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = CGPointMake((self.view.frame.width/2), 140)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        println("User Logged In")
        
        var accessToken = FBSDKAccessToken.currentAccessToken()
        println("FB User ID String: \(accessToken.userID)")
        println("Logged in with FB")
        
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    //facebook logout button is pressed and logout occurs
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")

    }
    
    //fetch facebook user data
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }

    @IBAction func start(sender: AnyObject) {
        var parseVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParseLoginController") as! ParseLoginController
        self.presentViewController(parseVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

