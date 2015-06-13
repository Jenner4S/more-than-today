//
//  EventPresenter.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 6/12/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import EventKit

class EventPresenter {
  private let oneDay: NSTimeInterval = 24 * 60 * 60 // in seconds
  private let event: EKEvent

  lazy private var timeFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateFormat = "HH:mm"
    return _formatter
  }()
  
  lazy private var weekdayFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateFormat = "EEEE"
    return _formatter
  }()

  lazy private var dateFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = .ShortStyle
    _formatter.timeStyle = .NoStyle
    return _formatter
  }()

  init(forEvent event: EKEvent) {
    self.event = event
  }

  var title: String {
    return event.title
  }

  var location: String {
    return event.location != "" ? event.location : "-"
  }

  var date: String {
    let startDate = event.startDate
    let oneWeekFromNow = NSDate(timeIntervalSinceNow: 7 * oneDay)
    if startDate < oneWeekFromNow {
      return weekdayFormatter.stringFromDate(startDate)
    } else {
      return dateFormatter.stringFromDate(startDate)
    }
  }

  var startTime: String {
    return timeFormatter.stringFromDate(event.startDate)
  }

  var endTime: String {
    return timeFormatter.stringFromDate(event.endDate)
  }
}

func < (left: NSDate, right: NSDate) -> Bool {
  return left.compare(right) == .OrderedAscending
}
