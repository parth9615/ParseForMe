//
//  ViewController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginController: UIViewController, FBSDKLoginButtonDelegate  {
    
    @IBOutlet weak var logoImageView: UIImageView!
    var window: UIWindow?
    var req:FBSDKGraphRequest?
    
    var userName:NSString?
    var userEmail:NSString?
    var dimView:DimView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = UIImage(named: "LogoandPic")
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        
        //UNCOMMENT IF YOU WANT TO ALLOW FACEBOOK LOGIN
        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//           self.returnUserData()
//        }
//        else {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            
//            loginView.frame = CGRectMake(self.view.frame.width/2, 200, 210, 40)
//            loginView.center = CGPointMake((self.view.frame.width/2), 340)
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
//            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkInternetConnection()
    }
    
    func checkInternetConnection() -> Bool {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            return true
        } else {
            //NO INTERNET CONNECTION..
            let alert = UIAlertController(title: "Oh No!", message: "You don't have internet connection right now and you need internet to access our app!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
                
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            print("Internet connection FAILED")
            return false
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print("User Logged In")
        
        print(result)
        print(result.declinedPermissions)
        print(result.grantedPermissions)
        let accessToken = FBSDKAccessToken.currentAccessToken()
        print("FB User ID String: \(accessToken.userID)")
        print("Logged in with FB")

        self.returnUserData()
        
        //loading view when waiting to fetch graph request.
        dimView = DimView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.view.addSubview(dimView!)
        self.view.bringSubviewToFront(dimView!)
        
        
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
    
    func finishLoading() {
        dimView?.removeFromSuperview()
        
        dispatch_async(dispatch_get_main_queue()) {
            //proceed to events page.
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let containerViewController = EventsContainerController()
            
            self.window!.rootViewController = containerViewController
            self.window!.makeKeyAndVisible()

        }
    }
    
    func alertUser(message: String) {
        if message == "no email registered facebook" {
            let alert = UIAlertController(title: "No Email Registered", message: "We're sorry, but there isn't a SyllaSync account registered with the email used for your Facebook, please create an account at our website, SyllaSync.com, on a computer to upload your syllabi.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
                
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if message == "no email registered gmail" {
            let alert = UIAlertController(title: "No Email Registered", message: "We're sorry, but there isn't a SyllaSync account registered with your gmail email, please create an account at our website, SyllaSync.com, on a computer to upload your syllabi.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
                
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //facebook logout button is pressed and logout occurs
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")

    }
    
    //fetch facebook user data
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields":"id, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if connection == nil {
                print("connection \(connection) equal to nil")
            }
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                self.userName = result.valueForKey("name") as? NSString
                self.userEmail = result.valueForKey("email") as? NSString
                
            
                let query = PFQuery(className: "Users")
                query.whereKey("email", equalTo: self.userEmail!)
                query.findObjectsInBackgroundWithBlock{(user: [AnyObject]?, error:NSError?) -> Void in
                    if error == nil {
                        print("query for facebook email user is succesful")
                        if let _ = user as? [PFUser!] {
                            print("There was in fact a user registered through facebook email")
                            
                            UserSettings.sharedInstance.Username = "\(self.userEmail!)"
                            self.finishLoading()
                        }
                        else {
                            print("There wasn't a user registered to that email")
                            
                            self.dimView?.removeFromSuperview()
                            self.alertUser("no email registered facebook")
                            //send an alert saying we either couldn't access their email or they don't have an account associated with that email
                        }
                    }
                    else {
                        print("Error", error, error!.userInfo)
                    }
                }

            }
        })
    }

    @IBAction func start(sender: AnyObject) {
        if checkInternetConnection() {
            let parseVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParseLoginController") as! ParseLoginController
            self.presentViewController(parseVC, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

