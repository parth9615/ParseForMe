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
    var fileToDisplay = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        //HARD CODED IN CALC SYLLABUS NEED TO CHANGEBACK TO SYLLABUSTODISPLAYSTRING WHEN DONE TESTING
        
        var query:PFQuery = PFQuery(className: "Events")
        query.whereKey("syllabus", equalTo:  "calcSyllabus.txt") //cast as a PFFile TODO
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error:NSError?) -> Void in
            if (error == nil) {
                print("got a query for calcSyllabus.txt")
                for object in objects! {
                    let userSyllabus = object["syllabus"] as! PFFile
                    userSyllabus.getDataInBackgroundWithBlock { // This is the part your overlooking
                        (imageData: NSData?, error:NSError?) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            self.fileToDisplay.append(image!)
                            
                            print(self.fileToDisplay)
                        }
                    }
                }
                print(self.fileToDisplay)
//                else {
//                    println("couldn't get syllabus for \(self.syllabusToDisplayString)")
//                }
            }
            else {
                print("Error", error, error!.userInfo)
            }
        }
        print(fileToDisplay)
        //self.syllabusViewer.image = fileToDisplay[0]
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
