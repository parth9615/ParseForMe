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
            print("user logged in")
            
            
            
            //let currentInstallation = PFInstallation.currentInstallation()
        
            
            UserSettings.sharedInstance.Username = self.user!.username
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let containerViewController = EventsContainerController()
            
            self.window!.rootViewController = containerViewController
            self.window!.makeKeyAndVisible()
            
        }
        else {
            print("No Logged in user")
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = "SyllaSync"
            logInLogoTitle.font = UIFont(name: "BoosterNextFY-Bold", size:28)
            
            
            let loginViewController = PFLogInViewController()
            loginViewController.logInView?.logo = logInLogoTitle
            loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton]
            loginViewController.emailAsUsername = true
            loginViewController.delegate = self
            
            let signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "SyllaSync"
            signUpLogoTitle.font = UIFont(name: "BoosterNextFY-Bold", size:28)
            
            let signupViewController = PFSignUpViewController()
            signupViewController.signUpView?.logo = signUpLogoTitle
            signupViewController.emailAsUsername = true
            signupViewController.delegate = self
            
            loginViewController.signUpController = signupViewController
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
        
        UserSettings.sharedInstance.Username = user.username!
        print("just completed loggin in for user: \(UserSettings.sharedInstance.Username)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        setInstallations(user)
    }
    
    func setInstallations(user: PFUser) {
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setObject(user.username!, forKey: "Username")
        currentInstallation.saveEventually()
        
        //TEST
//        user.setObject(currentInstallation, forKey: "installation")
//        user.saveEventually()
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to login")
    }
    
    //Mark: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("user dismissed signup")
    }
    
    //Mark: Actions
    
    @IBAction func logoutUser(sender: UIButton) {
        PFUser.logOut()
    }
    
    
    
}
