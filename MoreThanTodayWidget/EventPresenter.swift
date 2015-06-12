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
  private let event: EKEvent

  lazy private var timeFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateFormat = "HH:mm"
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
    return dateFormatter.stringFromDate(event.startDate)
  }

  var startTime: String {
    return timeFormatter.stringFromDate(event.startDate)
  }

  var endTime: String {
    return timeFormatter.stringFromDate(event.endDate)
  }
}
