//
//  AddEventScrollController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 10/22/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class AddEventScrollController: UIViewController {
    
    
    @IBOutlet weak var addEventScrollView: UIScrollView!
    var childVC:AddEventController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgba: "#04a4ca")
        
        childVC = storyboard?.instantiateViewControllerWithIdentifier("AddEventController") as? AddEventController
        childVC!.view.translatesAutoresizingMaskIntoConstraints = false
        addEventScrollView.addSubview(childVC!.view)
        
        addChildViewController(childVC!)
        childVC!.didMoveToParentViewController(self)
        childVC!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        let views = ["view": view, "childView": childVC!.view]
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[childView(==view)]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[childView(==view)]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
