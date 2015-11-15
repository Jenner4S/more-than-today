//
//  EventPresenter.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 6/12/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class EventPresenter {
  static let ALL_DAY = NSLocalizedString("all_day", tableName: "Widget", comment: "Text shown for events which are all day")
  static let DAYS_TEMPLATE = NSLocalizedString("days_template", tableName: "Widget", comment: "Template for showing the number of days")

  private let event: Event

  private static var timeFormatter: NSDateFormatter {
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
    return EventPresenter.timeFormatter.stringFromDate(event.start)
  }

  var endTime: String {
    return EventPresenter.timeFormatter.stringFromDate(event.end)
  }

  var numberOfDays: String {
    let days = DatesHelper.numberOfDaysFrom(event.start, to: event.end)
    return NSString.localizedStringWithFormat(EventPresenter.DAYS_TEMPLATE, days + 1) as String
  }

  static func longestSizeForEvents(events: [Event], inFont font: UIFont) -> CGFloat {
    var longest: CGFloat = 0.0
    for event in events {
      let startLength = timeFormatter.stringFromDate(event.start).lengthInFont(font)
      let endLength = timeFormatter.stringFromDate(event.end).lengthInFont(font)
      longest = max(longest, startLength, endLength)
    }
    let allDayLength = ALL_DAY.lengthInFont(font)
    return max(longest, allDayLength)
  }
}

func < (left: NSDate, right: NSDate) -> Bool {
  return left.compare(right) == .OrderedAscending
}

extension String {
  func lengthInFont(font: UIFont) -> CGFloat {
    return (self as NSString).sizeWithAttributes([NSFontAttributeName: font]).width
  }
}