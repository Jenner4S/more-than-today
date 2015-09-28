//
//  HeaderPresenter.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 9/28/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation

class HeaderPresenter {
  private static let TODAY = NSLocalizedString("today", tableName: "Widget", comment: "Date shown for events which occur today")
  private static let TOMORROW = NSLocalizedString("tomorrow", tableName: "Widget", comment: "Date shown for events which occur tomorrow")

  private let date: NSDate

  lazy private var weekdayFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateFormat = "EEEE"
    return _formatter
  }()

  lazy private var dateFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = .LongStyle
    _formatter.timeStyle = .NoStyle
    return _formatter
  }()

  var title: String {
    if date < DatesHelper.tomorrow {
      return HeaderPresenter.TODAY
    } else if date < DatesHelper.twoDaysFromNow {
      return HeaderPresenter.TOMORROW
    } else if date < DatesHelper.oneWeekFromNow {
      return weekdayFormatter.stringFromDate(date)
    } else {
      return dateFormatter.stringFromDate(date)
    }
  }

  init(forDate date: NSDate) {
    self.date = date
  }
}
