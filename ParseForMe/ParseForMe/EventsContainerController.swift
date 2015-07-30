//
//  EventsContainerController.swift
//  ParseForMe
//
//  Created by Joel Wasserman on 7/24/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import QuartzCore
import Parse

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
}

class EventsContainerController: UIViewController, UIPageViewControllerDataSource {
    
    
    
    private var pageViewController: UIPageViewController?
    
    var eventsArray:NSMutableArray = NSMutableArray()
    var calendarController: CalendarController?
    var eventsNavigationController: UINavigationController!
    var eventsController: EventsController?
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var pages = 2
    var hamburgerController: HamburgerController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getUserEvents()
        
        
        
          //****************************************************************************************** begin page vc stuff
   
     
           //****************************************************************************************** end page vc stuff
    }
    
    
    func getUserEvents() {
        var query: PFQuery = PFQuery(className: "Events")
        query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                println("got a query for \(UserSettings.sharedInstance.Username)")
                if let objects = objects as? [PFObject!] {
                    self.eventsArray.addObjectsFromArray(objects)
                    self.createPageViewController()
                    self.setupPageControl()
                }
            }
            else {
                println("Error", error, error!.userInfo!)
            }
        }     
    }
    


        //****************************************************************************************** begin page vc stuff
    private func createPageViewController() {
        
        let pageController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if pages > 0 {
            let firstController = getItemController(0)!
            if firstController is EventsController {
                eventsController = firstController as? EventsController
                eventsController!.delegate = self
                eventsController?.eventsArray = self.eventsArray
            }
            calendarController = getItemController(1)! as? CalendarController
            calendarController!.delegate = self
            calendarController!.eventsArray = self.eventsArray
            
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController is EventsController {
            let itemController = viewController as! EventsController
            
            if itemController.itemIndex > 0 {
                return getItemController(itemController.itemIndex-1)
            }
        }
        else if viewController is CalendarController {
            let itemController = viewController as! CalendarController
            
            if itemController.itemIndex > 0 {
                return getItemController(itemController.itemIndex-1)
            }
        }

        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController is EventsController {
            let itemController = viewController as! EventsController
            
            if itemController.itemIndex+1 < pages {
                return getItemController(itemController.itemIndex+1)
            }
        }
        else if viewController is CalendarController {
            let itemController = viewController as! CalendarController
            
            if itemController.itemIndex+1 < pages {
                return getItemController(itemController.itemIndex+1)
            }
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> UIViewController? {
        
        if itemIndex < pages {

            if itemIndex == 0 {
                if eventsController == nil {
                    eventsController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("EventsController") as? EventsController
                }
                eventsController?.itemIndex = itemIndex
                return eventsController
            }
            else {
                if calendarController == nil {
                    calendarController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("CalendarController") as? CalendarController
                }
                calendarController!.delegate = self
                calendarController?.itemIndex = itemIndex
                return calendarController
            }
            //pageItemController?.itemIndex = itemIndex
            //pageItemController.imageName = contentImages[itemIndex]
//            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    
    
    //****************************************************************************************** end page vc stuff
    
    
    
    
    
    
    
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
            
            addChildSidePanelController(hamburgerController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: HamburgerController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool, sender: AnyObject) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(eventsController!.view.frame) - centerPanelExpandedOffset, sender: sender)
        } else {
            animateCenterPanelXPosition(targetPosition: 0, sender: sender) { finished in
                self.currentState = .BothCollapsed
        
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, sender: AnyObject, completion: ((Bool) -> Void)! = nil) {
        if sender is EventsController {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.eventsController?.view.frame.origin.x = targetPosition
                }, completion: completion)
        }
        else if sender is CalendarController {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.calendarController?.view.frame.origin.x = targetPosition
                }, completion: completion)
        }
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            eventsController?.view.layer.shadowOpacity = 0.8
            calendarController?.view.layer.shadowOpacity = 0.8
        } else {
            eventsController?.view.layer.shadowOpacity = 0.0
            calendarController?.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func hamburgerController() -> HamburgerController? {
        var HamburgerStoryBoard = UIStoryboard(name: "Hamburger", bundle: nil)
        return HamburgerStoryBoard.instantiateViewControllerWithIdentifier("HamburgerController") as? HamburgerController
    }
    
    class func challengeViewController() -> EventsContainerController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("EventsContainerController") as? EventsContainerController
    }
    
}
