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
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
