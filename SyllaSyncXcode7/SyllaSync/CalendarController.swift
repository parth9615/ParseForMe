//
//  CalendarController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/9/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var deleteEventButton: UIButton!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var eventService = EventService.sharedInstance
    var CVDatesArray = [CVDate]()
    var CVMonthsArray = [Int]()
    var CVDaysArray = [Int]()
    var CVYearsArray = [Int]()
    var day:CVDate?
    var currentDayView:CVCalendarDayView?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        timeLabel.text = ""
        weightLabel.text = ""
        deleteEventButton.hidden = true
        deleteEventButton.enabled = false
        
        menuView.backgroundColor = UIColor.whiteColor()
        calendarView.backgroundColor = UIColor.whiteColor()
        getCVDatesFromDatesArray()
        askForNotifications()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        // Do any additional setup after loading the view.
    }
    
    func getCVDatesFromDatesArray() {
        for each in eventService.eventsArray {
            let dateFromString = each.date!.componentsSeparatedByString("/")
            let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
            CVDatesArray.append(newCVDate)
            CVMonthsArray.append(Int(dateFromString[0])!)
            CVDaysArray.append(Int(dateFromString[1])!)
            CVYearsArray.append(Int(dateFromString[2])!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    
        
        //GETS LOCATION
        
        locationManager.requestAlwaysAuthorization()
        
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.NotDetermined){
            print("Not Authorised")
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 1000.0
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        let user = PFUser.currentUser()
        user?.setObject(locValue.latitude, forKey: "Latitude")
        user?.setObject(locValue.longitude, forKey: "Longitude")
        user?.saveEventually()
        print("saving location to db")

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\n\nError for location manager CLLocation... line 71 in calendar controller\(error)\n\n")
    }
    
    
    @IBAction func deleteEvent(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this event?", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { _ in
            let query:PFQuery = PFQuery(className: "Events")
            query.whereKey("username", equalTo: UserSettings.sharedInstance.Username!)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error:NSError?) -> Void in
                if (error == nil) {
                    print("got a query for \(UserSettings.sharedInstance.Username)")
                    if let object = objects as? [PFObject!] {
                        for each in object {
                            if let event:AnyObject = each {
                                if let eventDetails:AnyObject = event["events"] {
                                    var title = ""
                                    var className = ""
                                    var date = ""
                                    
                                    if let eventTitle:AnyObject = eventDetails["Title"] {
                                        title = "\(eventTitle)"
                                    }
                                    if let eventClassName:AnyObject = eventDetails["Classname"] {
                                        className = "\(eventClassName)"
                                    }
                                    
                                    if let eventDate:AnyObject = eventDetails["Date"] {
                                        date = eventDate as! String
                                        let dateFromString = eventDate.componentsSeparatedByString("/")
                                        let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
                                        
                                        if newCVDate.day == self.day?.day && newCVDate.month == self.day?.month && title == self.titleLabel.text {
                                            print("\(self.titleLabel.text) event was deleted succesfully")
                                            each.deleteEventually()
                                            
                                            self.finishDeletion(className, date: date, title: title)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    print("Error getting query", error, error!.userInfo)
                }
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { _ in
        }
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func finishDeletion(className: String, date: String, title: String) {
        let deletionUUID = className+date+title
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["UUID"] as! String == deletionUUID {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        for each in UserSettings.sharedInstance.notificationsScheduled {
            if each.0 == deletionUUID {
                UserSettings.sharedInstance.notificationsScheduled.removeValueForKey(each.0)
            }
        }
        
        finishLoading()
    }
    
    func finishLoading() {
        //THIS ISN'T RELOADING VIEWS LIKE YOU WANT IT TO. EVERYHTING IS DELETING LIKE IT'S SUPPOSED TO THOUGH
     //   self.calendarView.reloadInputViews()
        getCVDatesFromDatesArray()
        calendarView = nil
        calendarView = CVCalendarView()
        calendarView.commitCalendarViewUpdate()
    }
    
    func askForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "eventAdded",
            name: EventServiceConstants.EventAdded,
            object: nil
        )
    }
    
    func eventAdded() {
        EventService.sharedInstance.countUniqueClasses(self)
    }
}


// MARK: - CVCalendarViewDelegate

extension CalendarController
{
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView
    {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView
    {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    {
        if dayView.date != nil {
            for var i = 0; i < CVMonthsArray.count; i++ {
                if CVYearsArray[i] == dayView.date.year && CVMonthsArray[i] == dayView.date.month && CVDaysArray[i] == dayView.date.day {
                    return true
                }
            }
        }
        return false
    }

    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        var tappedFlag = false
        day = dayView.date!
        currentDayView = dayView
        print("\(calendarView.presentedDate.commonDescription) is selected!")
        if dayView.date != nil {
            for var i = 0; i < CVMonthsArray.count; i++ {
                if CVYearsArray[i] == dayView.date.year && CVMonthsArray[i] == dayView.date.month && CVDaysArray[i] == dayView.date.day {
                    tappedFlag = true
                    
                    
                    self.titleLabel.text = eventService.eventsArray[i].title
                    self.timeLabel.text = eventService.eventsArray[i].time
                    self.weightLabel.text = "Worth \(eventService.eventsArray[i].weight!)% of your grade"
                    self.deleteEventButton.enabled = true
                    self.deleteEventButton.hidden = false
                    
                }
                else {
                    if tappedFlag == false {
                        tappedFlag = true
                        self.titleLabel.text = ""
                        self.timeLabel.text = ""
                        self.weightLabel.text = ""
                        self.deleteEventButton.enabled = false
                        self.deleteEventButton.hidden = true
                    }
                }
            }
        }
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date
        if CVDatesArray.contains(day) {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - CVCalendarMenuViewDelegate

extension CalendarController {
    // firstWeekday() has been already implemented.
}

// MARK: - IB Actions

extension CalendarController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension CalendarController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}
