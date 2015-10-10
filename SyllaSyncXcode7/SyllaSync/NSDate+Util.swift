// https://gist.github.com/icoxfog417/1ce24f4672a72b54dbb0

import Foundation

// TODO : rename cleanup once xcode supports renaming in swift
public struct DateFormats {
    public static var yearToMs:String {
        return "yyyy-MM-dd HH:mm:ss:SSS"
    }
    public static var yearToDay:String {
        return "yyyy-MM-dd"
    }
    public static var yearToMin:String {
        return "yyyy-MM-dd-HH-mm"
    }
    public static var monthToDay:String {
        return "M/d"
    }
    public static var recording:String {
        return "yyyy-MM-dd-HH-mm-ss-SSS"
    }
    public static var minuteSecond:String {
        return "mm:ss"
    }
    public static var hourMinuteSecond:String {
        return "HH:mm:ss"
    }
}

public extension NSDate {
    
    public struct DateFormatters {
        public static let yearToMs: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = DateFormats.yearToMs
            return dateFormatter
            }()
        public static let yearToDay: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = DateFormats.yearToDay
            return dateFormatter
            }()
        public static let monthToDay: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = DateFormats.monthToDay
            return dateFormatter
            }()
        public static let recording: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = DateFormats.recording
            return dateFormatter
            }()
        public static let minuteSecond: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = DateFormats.minuteSecond
            return dateFormatter
            }()
        public static let hourMinuteSecond: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            dateFormatter.dateFormat = DateFormats.hourMinuteSecond
            return dateFormatter
            }()
    }
    
    var calendar: NSCalendar {
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    }
    
    public var time : NSDate {
        get {
            let past = NSDate.distantPast() 
            return past.add(self.seconds, minutes: self.minutes, hours: self.hours)
        }
    }

    func minus(date: NSDate) -> NSDateComponents{
        return calendar.components(NSCalendarUnit.Minute, fromDate: self, toDate: date, options: NSCalendarOptions(rawValue: 0))
    }

    class func parse(dateString: String, format: String = DateFormats.yearToMs) -> NSDate {
        if format == DateFormats.yearToMs {
            return DateFormatters.yearToMs.dateFromString(dateString)!
        }
        else if format == DateFormats.yearToDay {
            return DateFormatters.yearToDay.dateFromString(dateString)!
        }
        else if format == DateFormats.monthToDay {
            return DateFormatters.monthToDay.dateFromString(dateString)!
        }
        else if format == DateFormats.recording {
            return DateFormatters.recording.dateFromString(dateString)!
        }
        else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = format
            return formatter.dateFromString(dateString)!
        }
    }
    
    class func today() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: NSDate())
        return calendar.dateFromComponents(components)!
    }

    class func dateToMinute(date:NSDate=NSDate()) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year, .Hour, .Minute], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    class func date(hour:Int, minute:Int, second:Int, fromDate:NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: fromDate)
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.dateFromComponents(components)!
    }

    func toString(format: String = DateFormats.yearToMs) -> String {
        if format == DateFormats.yearToMs {
            return DateFormatters.yearToMs.stringFromDate(self)
        }
        else if format == DateFormats.yearToDay {
            return DateFormatters.yearToDay.stringFromDate(self)
        }
        else if format == DateFormats.monthToDay {
            return DateFormatters.monthToDay.stringFromDate(self)
        }
        else if format == DateFormats.recording {
            return DateFormatters.recording.stringFromDate(self)
        }
        else if format == DateFormats.minuteSecond {
            return DateFormatters.minuteSecond.stringFromDate(self)
        }
        else if format == DateFormats.hourMinuteSecond {
            return DateFormatters.hourMinuteSecond.stringFromDate(self)
        }
        else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = format
            return formatter.stringFromDate(self)
        }
    }
    
    func dayString(format: String = DateFormats.yearToDay) -> String {
        if format != DateFormats.yearToDay {
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone.localTimeZone()
            formatter.dateFormat = format
            formatter.timeZone = NSTimeZone.localTimeZone()
            return formatter.stringFromDate(self)
        }
        return DateFormatters.yearToDay.stringFromDate(self)
    }
}
    