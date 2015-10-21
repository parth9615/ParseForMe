//
//  AddEventController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 10/16/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTF.delegate = self
        titleTF.delegate = self
        classNameTF.delegate = self
        weightTF.delegate = self
        timeTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.1
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
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
            let eventString:[String:AnyObject] = ["Classname":classNameTF.text!,"Date":dateTF.text!,"Time":timeTF.text!,"Title":titleTF.text!,"Weight":eventWeight!, "Syllabus":classNameTF.text!]
            newEvent["events"] = eventString
            newEvent["username"] = UserSettings.sharedInstance.Username
            newEvent["SyllabusFile"] = classNameTF.text!
            newEvent.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("object was saved")
                } else {
                    print("Error line 69 add event controller\(error)")
                }})
            let alert = UIAlertController(title: "", message: "\(titleTF.text!) was succesfully added to event database!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
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
