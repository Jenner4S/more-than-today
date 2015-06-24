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

private extension EKEvent {
  func toDictionary() -> [String: AnyObject] {
    return ["title": self.title,
      "location": self.location,
      "start": self.startDate,
      "end": self.endDate]
  }
  
  static func fromDictionary(properties: [String: AnyObject]) -> EKEvent {
    let event = EKEvent()
    event.title = properties["title"] as? String
    event.location = properties["location"] as? String
    event.startDate = properties["start"] as? NSDate
    event.endDate = properties["end"] as? NSDate
    return event
  }
}