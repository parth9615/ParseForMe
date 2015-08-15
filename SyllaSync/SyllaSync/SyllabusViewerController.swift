//
//  SyllabusViewerController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/14/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class SyllabusViewerController: UIViewController {

    @IBOutlet weak var syllabusViewer: UIImageView!
    var syllabusToDisplayString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //grabbing syllabus file from parse to stick in image view
        //TODO input syllabus file from parse into image view see if it is even possible
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
