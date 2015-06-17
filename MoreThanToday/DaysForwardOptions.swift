//
//  DaysForwardOptions.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/17/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation

struct DaysForwardOption {
  var title: String
  var value: Int
}

let DAYS_FORWARD_OPTIONS = [
  DaysForwardOption(title: localize("3days"), value: 3),
  DaysForwardOption(title: localize("1week"), value: 7),
  DaysForwardOption(title: localize("2weeks"), value: 14),
  DaysForwardOption(title: localize("1month"), value: 30)
]

private func localize(key: String) -> String {
  let key = "daysForward.\(key)"
  return NSLocalizedString(key, tableName: "Settings", comment: "")
}