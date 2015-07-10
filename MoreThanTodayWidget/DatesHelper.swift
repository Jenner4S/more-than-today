//
//  DatesHelper.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 6/15/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation

struct DatesHelper {
  private static let ONE_DAY: NSTimeInterval = 24 * 60 * 60 // in seconds
  private static let calendar = NSCalendar.currentCalendar()
  
  static var tomorrow: NSDate {
    return startOfDayForDaysFromNow(1)
  }
  
  static var twoDaysFromNow: NSDate {
    return startOfDayForDaysFromNow(2)
  }
  
  static var oneWeekFromNow: NSDate {
    return startOfDayForDaysFromNow(7)
  }
  
  static func startOfDayForDaysFromNow(days: Int) -> NSDate {
    return calendar.startOfDayForDate(NSDate(timeIntervalSinceNow: Double(days) * ONE_DAY))
  }
}
