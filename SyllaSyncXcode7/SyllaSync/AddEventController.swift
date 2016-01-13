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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.barTintColor = UIColor(rgba: "#04a4ca")
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "BoosterNextFY-Medium", size: 18)!
        ]
        self.navBar.titleTextAttributes = attributes

        dateTF.delegate = self
        titleTF.delegate = self
        classNameTF.delegate = self
        weightTF.delegate = self
        timeTF.delegate = self
        
        classNameTF.autocorrectionType = UITextAutocorrectionType.No
        titleTF.autocorrectionType = UITextAutocorrectionType.No
        
        dateTF.addTarget(self, action: "editingDateTF:", forControlEvents: UIControlEvents.EditingDidEnd)
        weightTF.addTarget(self, action: "editingWeightTF:", forControlEvents: UIControlEvents.EditingDidEnd)
        
        let fontSize = self.titleLabel.font.pointSize
        dateLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        titleLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        classNameLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        weightLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        timeLabel.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        
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
    
    func editingWeightTF(sender: UITextField) {
        let regexPatterns = ["^[0-9][0-9]?$|^100$"]
        
        if sender.text?.characters.last == "%" {
            sender.text = sender.text?.stringByReplacingOccurrencesOfString("%", withString: "")
        }
        
        let regexes = try! NSRegularExpression(pattern: regexPatterns[0], options: [])
        
        let text = sender.text!
        let range = NSMakeRange(0, text.length)
        
        let matchRange = regexes.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
        
        let valid = matchRange.location != NSNotFound
        
        if !valid {
            let alert = UIAlertController(title: "Invalid Weight Format", message: "The Weight must be between 0-100%", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                self.weightTF.text = ""
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func editingDateTF(sender: UITextField) {
        let regexPatterns = ["^(0[1-9]|[1-9]|1[012])[-/.](0[1-9]|[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$"]
        
        let regexes = try! NSRegularExpression(pattern: regexPatterns[0], options: [])
        
        let text = sender.text!
        let range = NSMakeRange(0, text.length)
        
        let matchRange = regexes.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
        
        let valid = matchRange.location != NSNotFound
        
        if !valid {
            let alert = UIAlertController(title: "Invalid Date Format", message: "The Date TextField must have a valid date of format ##/##/####", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                self.dateTF.text = ""
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            self.view.frame = CGRectOffset(self.view.frame, 0, -50)
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
            
            if dateTF.text?.length == 2 {
                dateTF.text = "20"+dateTF.text!
            }
            if weightTF.text == "" {
                weightTF.text = "0"
            }
            if weightTF.text?.characters.last! == "%" {
                weightTF.text = weightTF.text?.stringByReplacingOccurrencesOfString("%", withString: "")
            }
            let eventWeight:Int? = Int(weightTF.text!)
            
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
                        event.newEvent = true
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
                    print("Error line 139 add event controller\(error)")
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
            var missingString = ""
            if classNameTF.text == "" {
                missingString += "The Classname"
            }
            if titleTF.text == "" {
                missingString += " and Title"
            }
            if dateTF.text == "" {
                missingString += " and Date"
            }
            let alert = UIAlertController(title: "Error", message: "\(missingString) field(s) was/were left blank, please fill them in to continue.", preferredStyle: .Alert)
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
