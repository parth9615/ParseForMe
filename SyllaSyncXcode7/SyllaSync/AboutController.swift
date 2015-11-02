//
//  AboutController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation

class AboutController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var goHeelsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontSize = self.aboutUsLabel.font.pointSize
        aboutUsLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        goHeelsLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
