//
//  UIViewExtension.swift
//

// Thanks to Leonardo Dabus for many of the functions here.

import UIKit

extension NSDate {
    
    convenience init(dateString: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        
        self.init(timeInterval:0, sinceDate:d!)
    }
    
    class func at(year year: Int?, month: Int?, day: Int?) -> NSDate? {
        let dateStr = "\(year!)-\(month!)-\(day!)"
        
        return NSDate(dateString: dateStr)
    }
    
    /// Returns the number of years `Int` from the date (`self`) in relation to the given date `NSDate`.
    ///
    ///  - parameter date:           The date object you want to compare to.
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
    }
    
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
    }
    
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: []).day
    }
    
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: []).hour
    }
    
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: []).minute
    }
    
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: []).second
    }
    
    func minute() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: self)
        return components.minute
    }
    
    func hour() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: self)
        return components.hour
    }
    
    func day() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: self)
        return components.day
    }
    
    func month() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Month, fromDate: self)
        return components.month
    }
    
    func year() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: self)
        return components.year
    }
    
    func dayAndMonth() -> String {
        let deviceLanguage = NSLocale.preferredLanguages().first as String!
        let dateFormatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: deviceLanguage)
        
        dateFormatter.dateFormat = "LLL dd"
        dateFormatter.locale = locale
        
        let dateString = dateFormatter.stringFromDate(self)
        
        return dateString
    }
}