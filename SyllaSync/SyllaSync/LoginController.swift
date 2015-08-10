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

class LoginController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    @IBOutlet weak var logoImageView: UIImageView!
    var window: UIWindow?
    var req:FBSDKGraphRequest?
    
    var userName:NSString?
    var userEmail:NSString?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = UIImage(named: "LogoandPic")
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
        
        println(GIDSignIn.sharedInstance().currentUser)
        if GIDSignIn.sharedInstance().currentUser != nil {
            //skipToChallenges()
        }
        else {
            let loginView:GIDSignInButton = GIDSignInButton()
            self.view.addSubview(loginView)
            loginView.center = CGPointMake((self.view.frame.width/2), 420)
        }
        
        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//           self.returnUserData()
//        }
//        else {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = CGPointMake((self.view.frame.width/2), 340)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        var dimView:DimView?
        
        println("User Logged In")
        
        println(result)
        println(result.declinedPermissions)
        println(result.grantedPermissions)
        var accessToken = FBSDKAccessToken.currentAccessToken()
        println("FB User ID String: \(accessToken.userID)")
        println("Logged in with FB")

        self.returnUserData()
        
        
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            var query = PFQuery(className: "Users")
            query.whereKey("email", equalTo: self.userEmail!)
            query.findObjectsInBackgroundWithBlock{(user: [AnyObject]?, error:NSError?) -> Void in
                if error == nil {
                    println("query for facebook email user is succesful")
                    if let objects = user as? [PFUser!] {
                        println("There was in fact a user registered through facebook email")
                        
                        dimView?.removeFromSuperview()
                        UserSettings.sharedInstance.Username = "\(objects)"
                        //proceed to events page.
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        let containerViewController = EventsContainerController()
                        
                        self.window!.rootViewController = containerViewController
                        self.window!.makeKeyAndVisible()
                    }
                    else {
                        println("There wasn't a user registered to that email")
                            
                        dimView?.removeFromSuperview()
                        self.alertUser("no email registered facebook")
                        //send an alert saying we either couldn't access their email or they don't have an account associated with that email
                    }
                }
                else {
                    println("Error", error, error!.userInfo!)
                }
            }
        }
        
        
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
    
    func alertUser(message: String) {
        if message == "no email registered facebook" {
            var alert = UIAlertController(title: "No Email Registered", message: "We're sorry, but there isn't an account registered with the email used for your Facebook, please create an account at our website, SyllaSync.com, on a computer", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //facebook logout button is pressed and logout occurs
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")

    }
    
    //fetch facebook user data
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields":"id, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if connection == nil {
                println("connection \(connection) equal to nil")
            }
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                self.userName = result.valueForKey("name") as? NSString
                println("User Name is: \(self.userName)")
                self.userEmail = result.valueForKey("email") as? NSString
                println("User Email is: \(self.userEmail)")
                
            
                
                println(result)
                println(self.userEmail)
                println(self.userName)
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

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                
                
                //TO DO: INTEGRATE GOOGLE WITH PARSE USER LOGINS
                
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let name = user.profile.name
                let email = user.profile.email
                
                println(email)
                // ...
            } else {
                println("\(error.localizedDescription)")
            }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
    }

}

