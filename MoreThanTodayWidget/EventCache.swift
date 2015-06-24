//
//  EventCache.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/24/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import EventKit

class EventCache {
  private static let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)
  
  static func eventsFromCache() -> [EKEvent] {
    if let eventDictionaries = defaults?.objectForKey(DefaultsConstants.EVENTS_CACHE_KEY) as? [[String: AnyObject]] {
      return eventDictionaries.map { EKEvent.fromDictionary($0) }
    }
    return []
  }
  
  static func cacheEvents(events: [EKEvent]) {
    let eventDictionaries = events.map { $0.toDictionary() }
    defaults?.setObject(eventDictionaries, forKey: DefaultsConstants.EVENTS_CACHE_KEY)
    defaults?.synchronize()
  }
}

private let TITLE_KEY = "title"
private let LOCATION_KEY = "location"
private let START_KEY = "start"
private let END_KEY = "end"

private extension EKEvent {
  func toDictionary() -> [String: AnyObject] {
    return [TITLE_KEY: self.title,
      LOCATION_KEY: self.location,
      START_KEY: self.startDate,
      END_KEY: self.endDate]
  }
  
  static func fromDictionary(properties: [String: AnyObject]) -> EKEvent {
    let event = EKEvent(eventStore: EKEventStore())
    event.title = properties[TITLE_KEY] as? String
    event.location = properties[LOCATION_KEY] as? String
    event.startDate = properties[START_KEY] as? NSDate
    event.endDate = properties[END_KEY] as? NSDate
    return event
  }
}