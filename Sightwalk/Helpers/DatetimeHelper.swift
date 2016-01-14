//
//  DatetimeHelper.swift
//  Sightwalk
//
//  Created by Boris Besemer on 14-01-16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import Foundation

class DatetimeHelper {
    enum Compare {
        case Week
        case Month
    }
    
    static func getBeginDate(type: Compare) -> NSDate? {
        let now = NSDate()
        let currentCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents?
        
        switch type {
        case .Week:
            components = currentCalendar.components([.WeekOfYear, .YearForWeekOfYear], fromDate: now)
            return currentCalendar.dateFromComponents(components!)
        case .Month:
            components = currentCalendar.components(.Month, fromDate: now)
            return NSDate(timeIntervalSinceNow: -2629743.83)
        }
    }
}