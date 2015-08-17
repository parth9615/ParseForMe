//
//  EventsContainerController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import QuartzCore
import Parse

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
}

class EventsContainerController: UIViewController {
    
    
    var eventService = EventService.sharedInstance
    var dimView:DimView?
    var tableCalendarController: TableCalendarContainerController?
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var index = 0
    var hamburgerController: HamburgerController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         getUserEvents()
        var currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation["userID"] = PFUser.currentUser()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func getUserEvents() {
        
        
        
        //loading view when waiting to fetch graph request.
        dimView = DimView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.view.addSubview(dimView!)
        self.view.bringSubviewToFront(dimView!)
        
        checkInternetConnection()
        
        eventService.getJSON(self as UIViewController)
    }
    
    func checkInternetConnection() -> Bool {
        if Reachability.isConnectedToNetwork() == true {
            println("Internet connection OK")
            return true
        } else {
            //NO INTERNET CONNECTION..
            var alert = UIAlertController(title: "Oh No!", message: "You don't have internet connection right now and you need internet to access our app!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
                PFUser.logOut()
                
                var loginStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                var loginVC = loginStoryBoard.instantiateViewControllerWithIdentifier("Login") as! LoginController
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            println("Internet connection FAILED")
            return false
        }
    }
    
    func finishedLoading() {
        dimView?.removeFromSuperview()
        
        if tableCalendarController == nil {
            tableCalendarController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("containerController") as? TableCalendarContainerController
        }
        view.addSubview(tableCalendarController!.view)
        addChildViewController(tableCalendarController!)
        tableCalendarController?.didMoveToParentViewController(self)
        tableCalendarController!.delegate = self
    }
    
    
    //Hamburger code
}

extension EventsContainerController: EventsContainerControllerDelegate {
    
    func toggleLeftPanel(sender :AnyObject) {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
    
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded, sender: sender)
    }
    
    func addLeftPanelViewController() {
        if (hamburgerController == nil) {
            hamburgerController = UIStoryboard.hamburgerController()
            
            hamburgerController?.parent = self
            addChildSidePanelController(hamburgerController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: HamburgerController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        //self.view.bringSubviewToFront(sidePanelController.view)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool, sender: AnyObject) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(tableCalendarController!.view.frame) - centerPanelExpandedOffset, sender: sender)
        } else {
            animateCenterPanelXPosition(targetPosition: 0, sender: sender) { finished in
                self.currentState = .BothCollapsed
                
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, sender: AnyObject, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tableCalendarController!.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            tableCalendarController?.view.layer.shadowOpacity = 0.8
        } else {
            tableCalendarController?.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func hamburgerController() -> HamburgerController? {
        var HamburgerStoryBoard = UIStoryboard(name: "Hamburger", bundle: nil)
        return HamburgerStoryBoard.instantiateViewControllerWithIdentifier("Hamburger") as? HamburgerController
    }
    
    class func challengeViewController() -> EventsContainerController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("EventsContainerController") as? EventsContainerController
    }
    
}
