//
//  ParseLoginController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseLoginController: UIViewController, PFLogInViewControllerDelegate,
PFSignUpViewControllerDelegate {
    
    var window: UIWindow?
    var user:PFUser?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        user = PFUser.currentUser()
        if user != nil {
            //move to new view controller
            
            UserSettings.sharedInstance.Username = user!.username
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let containerViewController = EventsContainerController()
            
            window!.rootViewController = containerViewController
            window!.makeKeyAndVisible()
        }
        else {
            println("No Logged in user")
            var loginViewController = PFLogInViewController()
            loginViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton
            
            loginViewController.delegate = self
            
            var signupViewController = PFSignUpViewController()
            signupViewController.delegate = self
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if(!username.isEmpty || !password.isEmpty){
            return true
        }else{
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        UserSettings.sharedInstance.Username = user.username!
        println("just completed loggin in for user: \(UserSettings.sharedInstance.Username)")
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("failed to login")
    }
    
    //Mark: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("user dismissed signup")
    }
    
    //Mark: Actions
    
    @IBAction func logoutUser(sender: UIButton) {
        PFUser.logOut()
    }
    
    

}
