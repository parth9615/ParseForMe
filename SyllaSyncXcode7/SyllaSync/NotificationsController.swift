//
//  CompareController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    var childVC:NotificationSettingsVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scroll view
        childVC = storyboard?.instantiateViewControllerWithIdentifier("NotificationSettingsVC") as? NotificationSettingsVC
        childVC!.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        childVC!.view.translatesAutoresizingMaskIntoConstraints = true
        scrollView.addSubview(childVC!.view)
        scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, self.scrollView.frame.height)
        
        addChildViewController(childVC!)
        childVC!.didMoveToParentViewController(self as NotificationsController)
        //end scroll view
        
        let fontSize = self.descriptionLabel.font.pointSize
        descriptionLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        titleLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
