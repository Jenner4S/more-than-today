//
//  EventCache.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/24/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation

class EventCache {
  private static let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)
  
  static func eventsFromCache() -> [[Event]] {
    if let data = defaults?.objectForKey(DefaultsConstants.EVENTS_CACHE_KEY) as? NSData,
      events = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [[Event]] {
        return events
    }
    return []
  }
  
  static func cacheEvents(events: [[Event]]) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(events)
    defaults?.setObject(data, forKey: DefaultsConstants.EVENTS_CACHE_KEY)
    defaults?.synchronize()
  }
}
