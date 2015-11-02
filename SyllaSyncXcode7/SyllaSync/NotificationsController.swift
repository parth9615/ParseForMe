//
//  CompareController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

public enum NotificationCells: Int {
    case BarEvents = 0
    case SportEvents
}

class NotificationsController: UIViewController {
    
    @IBOutlet weak var barEventsToggle: UISwitch!
    @IBOutlet weak var sportEventsToggle: UISwitch!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barDealLabel: UILabel!
    @IBOutlet weak var sportEventLabel: UILabel!

    //
    //  HamburgerController.swift
    //  SyllaSync
    //
    //  Created by Joel Wasserman on 8/1/15.
    //  Copyright (c) 2015 IVET. All rights reserved.
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barEventsToggle.addTarget(self, action: Selector("barStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        sportEventsToggle.addTarget(self, action: Selector("sportStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let fontSize = self.descriptionLabel.font.pointSize
        descriptionLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        titleLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        barDealLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        sportEventLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func barStateChanged(switchState: UISwitch) {
        if switchState.on {
            UserSettings.sharedInstance.BarEvents = true
        } else {
            UserSettings.sharedInstance.BarEvents = false
        }
    }
    
    func sportStateChanged(switchState: UISwitch) {
        if switchState.on {
            UserSettings.sharedInstance.SportEvents = true
        } else {
            UserSettings.sharedInstance.SportEvents = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
