//
//  Event.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 7/19/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import EventKit

private let IDENTIFIER_KEY = "identifier"
private let TITLE_KEY = "title"
private let LOCATION_KEY = "location"
private let START_KEY = "start"
private let END_KEY = "end"
private let ALL_DAY_KEY = "allDay"

class Event: NSObject, NSCoding, Equatable {
  let identifier: String
  let title: String
  let location: String
  let start: NSDate
  let end: NSDate
  let allDay: Bool

  init(ekEvent: EKEvent) {
    self.identifier = ekEvent.eventIdentifier
    self.title = ekEvent.title
    self.location = ekEvent.location
    self.start = ekEvent.startDate
    self.end = ekEvent.endDate
    self.allDay = ekEvent.allDay
  }

  required init(coder decoder: NSCoder) {
    self.identifier = decoder.decodeObjectForKey(IDENTIFIER_KEY) as! String
    self.title = decoder.decodeObjectForKey(TITLE_KEY) as! String
    self.location = decoder.decodeObjectForKey(LOCATION_KEY) as! String
    self.start = decoder.decodeObjectForKey(START_KEY) as! NSDate
    self.end = decoder.decodeObjectForKey(END_KEY) as! NSDate
    self.allDay = decoder.decodeBoolForKey(ALL_DAY_KEY)
  }

  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.identifier, forKey: IDENTIFIER_KEY)
    coder.encodeObject(self.title, forKey: TITLE_KEY)
    coder.encodeObject(self.location, forKey: LOCATION_KEY)
    coder.encodeObject(self.start, forKey: START_KEY)
    coder.encodeObject(self.end, forKey: END_KEY)
    coder.encodeBool(self.allDay, forKey: ALL_DAY_KEY)
  }
}

func == (left: Event, right: Event) -> Bool {
  return left.identifier == right.identifier
}