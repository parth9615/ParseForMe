//
//  CalendarController.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/9/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var childVC:DayEventsController?
    
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
    var day:DayView?
    var currentDayView:CVCalendarDayView?
    var eventsAdded = false
    var eventAddedCalendar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //scroll view
        childVC = storyboard?.instantiateViewControllerWithIdentifier("DayEvents") as? DayEventsController
        childVC!.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        childVC!.view.translatesAutoresizingMaskIntoConstraints = true
        scrollView.addSubview(childVC!.view)
        scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, self.scrollView.frame.height)
        
        addChildViewController(childVC!)
        childVC!.didMoveToParentViewController(self as CalendarController)
        

        
        menuView.backgroundColor = UIColor.whiteColor()
        calendarView.backgroundColor = UIColor.whiteColor()
        getCVDatesFromDatesArray() {
            (result: String) in
        }
        askForNotifications()
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        // Do any additional setup after loading the view.

        

    
    }
    
    func getCVDatesFromDatesArray(completion:(result: String) -> Void) {
        CVDatesArray.removeAll()
        CVMonthsArray.removeAll()
        CVDaysArray.removeAll()
        CVYearsArray.removeAll()
        
        for each in eventService.eventsArray {
            let dateFromString = each.date!.componentsSeparatedByString("/")
            let newCVDate = CVDate(day: Int(dateFromString[1])!, month: Int(dateFromString[0])!, week: ((Int(dateFromString[1])!)/7)+1, year: Int(dateFromString[2])!)
            if each.newEvent == true {
                each.newEvent = false
            }
            CVDatesArray.append(newCVDate)
            CVMonthsArray.append(Int(dateFromString[0])!)
            CVDaysArray.append(Int(dateFromString[1])!)
            CVYearsArray.append(Int(dateFromString[2])!)
        }
        completion(result: "finished")
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
        
        
        
        if self.eventsAdded {
            self.eventsAdded = false
            let alert = UIAlertController(title: "Events Added", message: "Your new events have been added to our database and your reminders have been scheduled, please give us a moment to draw circles on your calendar", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { _ in
                self.eventService.countUniqueClasses(self)
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
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

    
    func finishLoading(sender: String) {
        
        getCVDatesFromDatesArray() {
            (result: String) in
            if sender == "deletion" {
                if let dayV = self.day {
                    self.didSelectDayView(dayV)
            
                    for each in dayV.subviews {
                        
                        if each is UILabel {
                            continue
                        }
                        else if each is CVAuxiliaryView {
                            continue
                        }
                        else {
                            each.removeFromSuperview()
                            break
                        }
                    }
                }
            }
            if sender == "addition" {
                //print("hit addition")
                for each in self.calendarView.contentController.presentedMonthView.weekViews {
                    for dayView in each.dayViews {
                        for eachDate in self.CVDatesArray {
                            if dayView.date.day == eachDate.day && dayView.date.month == eachDate.month && dayView.date.year == eachDate.year {
                                dayView.preliminarySetup()
                                dayView.supplementarySetup()
                            }
                        }
                    }
                }
            }
            if sender == "deletionAddition" {
                if let dayV = self.day {
                    self.didSelectDayView(dayV)
                    
                    for each in dayV.subviews {
                        if each is UILabel {
                            continue
                        }
                        else if each is CVAuxiliaryView {
                            continue
                        }
                        else {
                            each.removeFromSuperview()
                            break
                        }
                    }
                }
                
                for each in self.calendarView.contentController.presentedMonthView.weekViews {
                    for dayView in each.dayViews {
                        for eachDate in self.CVDatesArray {
                            if dayView.date.day == eachDate.day && dayView.date.month == eachDate.month && dayView.date.year == eachDate.year {
                                dayView.preliminarySetup()
                                dayView.supplementarySetup()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func askForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "eventAdded",
            name: EventServiceConstants.EventAdded,
            object: nil
        )
    }
    
    func eventAdded() {
        if self.eventAddedCalendar {
            eventAddedCalendar = false
            eventsAdded = true
        }
    }
}






/*************************************************************************************************************************************************
 ********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
 
 
 
 
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
            day = dayView
            var tappedFlag = false
            
            self.childVC?.numberOfEventsOnDay = 0
            self.childVC?.eventDates.removeAll()
            self.childVC?.eventTitles.removeAll()
            self.childVC?.eventTimes.removeAll()
            self.childVC?.eventWeights.removeAll()
            self.childVC?.eventLocations.removeAll()
            self.childVC?.eventClasses.removeAll()
            self.childVC?.eventDescriptions.removeAll()
            self.childVC?.reloadTable()
            
            if dayView.date != nil {
                for var i = 0; i < CVMonthsArray.count; i++ {
                    if CVYearsArray[i] == dayView.date.year && CVMonthsArray[i] == dayView.date.month && CVDaysArray[i] == dayView.date.day {
                        tappedFlag = true
                        
                        self.childVC?.numberOfEventsOnDay++
                        self.childVC?.eventDates.append("\(CVMonthsArray[i])/\(CVDaysArray[i])/\(CVYearsArray[i])")
                        self.childVC?.eventTitles.append(eventService.eventsArray[i].title!)
                        self.childVC?.eventTimes.append(eventService.eventsArray[i].time!)
                        self.childVC?.eventWeights.append(eventService.eventsArray[i].weight!)
                        self.childVC?.eventClasses.append(eventService.eventsArray[i].className!)
                        if let desc = eventService.eventsArray[i].eventDescription {
                            self.childVC?.eventDescriptions.append(desc)
                        }
                        else {
                            self.childVC?.eventDescriptions.append("")
                        }
                        
                        self.childVC?.reloadTable()
                        
                    }
                    else {
                        if tappedFlag == false {
                            tappedFlag = true
                        }
                    }
                }
            }
            
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
        day = dayView
        currentDayView = dayView
        
        self.childVC?.numberOfEventsOnDay = 0
        self.childVC?.eventDates.removeAll()
        self.childVC?.eventTitles.removeAll()
        self.childVC?.eventTimes.removeAll()
        self.childVC?.eventWeights.removeAll()
        self.childVC?.eventLocations.removeAll()
        self.childVC?.eventClasses.removeAll()
        self.childVC?.eventDescriptions.removeAll()
        self.childVC?.reloadTable()
        
        print("\(calendarView.presentedDate.commonDescription) is selected!")
        if dayView.date != nil {
            for var i = 0; i < CVMonthsArray.count; i++ {
                if CVYearsArray[i] == dayView.date.year && CVMonthsArray[i] == dayView.date.month && CVDaysArray[i] == dayView.date.day {
                    tappedFlag = true
                    
                    self.childVC?.numberOfEventsOnDay++
                    self.childVC?.eventDates.append("\(CVMonthsArray[i])/\(CVDaysArray[i])/\(CVYearsArray[i])")
                    self.childVC?.eventTitles.append(eventService.eventsArray[i].title!)
                    self.childVC?.eventTimes.append(eventService.eventsArray[i].time!)
                    self.childVC?.eventWeights.append(eventService.eventsArray[i].weight!)
                    self.childVC?.eventClasses.append(eventService.eventsArray[i].className!)
                    if let desc = eventService.eventsArray[i].eventDescription {
                        self.childVC?.eventDescriptions.append(desc)
                    }
                    else {
                        self.childVC?.eventDescriptions.append("")
                    }
                    
                    self.childVC?.reloadTable()
           
                }
                else {
                    if tappedFlag == false {
                        tappedFlag = true
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
        _ = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}
