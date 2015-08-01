//
//  ViewController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/1/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func start(sender: AnyObject) {
        var parseVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParseLoginController") as! ParseLoginController
        self.presentViewController(parseVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

