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
  private static let TODAY = NSLocalizedString("widget.today", tableName: "Widget", bundle: NSBundle.mainBundle(), value: "Today", comment: "Date shown for events which occur today")
  private static let TOMORROW = NSLocalizedString("widget.tomorrow", tableName: "Widget", bundle: NSBundle.mainBundle(), value: "Tomorrow", comment: "Date shown for events which occur tomorrow")

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
    if startDate < DatesHelper.tomorrow {
      return EventPresenter.TODAY
    } else if startDate < DatesHelper.twoDaysFromNow {
      return EventPresenter.TOMORROW
    } else if startDate < DatesHelper.oneWeekFromNow {
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
