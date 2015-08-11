//
//  InviteController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation

class InviteController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var alert = UIAlertController(title: "We're Sorry", message: "This feature is not available at this time", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
