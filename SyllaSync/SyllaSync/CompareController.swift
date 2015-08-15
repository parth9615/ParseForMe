//
//  CompareController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class CompareController: UIViewController {
    
    
    @IBOutlet weak var classmatesTable: UITableView!
    @IBOutlet weak var compareTextField: UITextField!
    
    
    //have a text field where they can enter either an email or a phone number
    // submit button where they can send the compare invite
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO this is where you get the current classmates from parse
        //TODO create a new table in parse. classmates will be mapped to a username then we can request a query to that specific database and 
    }

    @IBAction func compare(sender: AnyObject) {
        //TODO implelment compare algo by comparing syllabi on Parse
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
