//
//  EventTodayDescriptionController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 1/7/16.
//  Copyright © 2016 IVET. All rights reserved.
//

import UIKit

class EventTodayDescriptionController: UIViewController {

    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var eventClass:String?
    var eventTitle:String?
    var time:String?
    var location:String?
    var group:String?
    var eventDescription:String?
    var price:String?
    
    var classHidden = false
    var titleHidden = false
    var timeHidden = false
    var locationHidden = false
    var groupHidden = false
    var descriptionHidden = false
    var priceHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if classHidden {
            classLabel.hidden = true
        }
        if titleHidden {
            titleLabel.hidden = true
        }
        if timeHidden {
            timeLabel.hidden = true
        }
        if locationHidden {
            locationLabel.hidden = true
        }
        if groupHidden {
            groupLabel.hidden = true
        }
        if descriptionHidden {
            descriptionLabel.hidden = true
        }
        if priceHidden {
            priceLabel.hidden = true
        }
        
        let fontSize = self.descriptionLabel.font.pointSize
        classLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        classLabel.text = eventClass
        titleLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        titleLabel.text = eventTitle
        timeLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        timeLabel.text = time
        locationLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        locationLabel.text = location
        groupLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        groupLabel.text = group
        descriptionLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        descriptionLabel.text = eventDescription
        priceLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        priceLabel.text = price
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        classHidden = false
        titleHidden = false
        timeHidden = false
        locationHidden = false
        groupHidden = false
        descriptionHidden = false
        priceHidden = false
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
