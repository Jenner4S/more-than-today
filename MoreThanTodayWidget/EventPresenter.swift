//
//  EventPresenter.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 6/12/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation

class EventPresenter {
  static let ALL_DAY = NSLocalizedString("all_day", tableName: "Widget", comment: "Text shown for events which are all day")

  private let event: Event

  private var timeFormatter: NSDateFormatter {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = .NoStyle
    _formatter.timeStyle = .ShortStyle
    return _formatter
  }
  
  init(forEvent event: Event) {
    self.event = event
  }

  var title: String {
    return event.title
  }

  var location: String {
    return event.location != "" ? event.location : "-"
  }

  var startTime: String {
    return timeFormatter.stringFromDate(event.start)
  }

  var endTime: String {
    return timeFormatter.stringFromDate(event.end)
  }
}

func < (left: NSDate, right: NSDate) -> Bool {
  return left.compare(right) == .OrderedAscending
}
