//
//  AddEventController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 10/16/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    var originalFrame : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTF.delegate = self
        titleTF.delegate = self
        classNameTF.delegate = self
        weightTF.delegate = self
        timeTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        originalFrame = self.view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Top
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false)
    }
    
    func animateViewMoving (up:Bool){
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.2)
        if up {
            self.view.frame = CGRectOffset(self.view.frame, 0, -100)
        }
        else {
            self.view.frame = originalFrame!
        }
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitEvent(sender: AnyObject) {
        if classNameTF.text != "" && dateTF.text != "" && titleTF.text != ""  {
            let newEvent = PFObject(className: "Events")
            let eventWeight:Int? = Int(weightTF.text!)
            
            if dateTF.text?.length == 2 {
                dateTF.text = "20"+dateTF.text!
            }
            
            let eventString:[String:AnyObject] = ["Classname":classNameTF.text!,"Date":dateTF.text!,"Time":timeTF.text!,"Title":titleTF.text!,"Weight":eventWeight!, "Syllabus":classNameTF.text!]
            newEvent["events"] = eventString
            newEvent["username"] = UserSettings.sharedInstance.Username
            newEvent["SyllabusFile"] = classNameTF.text!
            newEvent.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("object was saved")
                    let alert = UIAlertController(title: "", message: "\(self.titleTF.text!) was succesfully added to event database!", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                        let event = Event()
                        event.className = self.classNameTF.text
                        event.date = self.dateTF.text
                        event.syllabus = self.classNameTF.text
                        event.time = self.timeTF.text
                        event.title = self.titleTF.text
                        event.weight = Int(self.weightTF.text!)
                        event.UUID = event.className!+event.date!+event.title!
                        EventService.sharedInstance.eventsArray.append(event)
                        
                        self.dateTF.text = ""
                        self.titleTF.text = ""
                        self.classNameTF.text = ""
                        self.weightTF.text = ""
                        self.timeTF.text = ""
                        NSNotificationCenter.defaultCenter().postNotificationName(EventServiceConstants.EventAdded, object: nil)
                    }
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    print("Error line 72 add event controller\(error)")
                    let alert = UIAlertController(title: "", message: "Error saving event, please try again", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                        self.dateTF.text = ""
                        self.titleTF.text = ""
                        self.classNameTF.text = ""
                        self.weightTF.text = ""
                        self.timeTF.text = ""
                    }
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }})
        }
        else {
            let alert = UIAlertController(title: "Error", message: "One or more critical fields was left blank, please fill them in to continue", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
