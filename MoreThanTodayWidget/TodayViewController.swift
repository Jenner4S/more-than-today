//
//  TodayViewController.swift
//  MoreThanTodayWidget
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit
import NotificationCenter
import EventKit

class TodayViewController: UIViewController, NCWidgetProviding {

  private let store = EKEventStore()
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)
  private var events = [Event]()

  private var daysForward: Int {
    if let days = defaults?.integerForKey(DefaultsConstants.DAYS_FORWARD_KEY) {
      return days > 0 ? days : DefaultsConstants.DEFAULT_DAYS_FORWARD
    }
    return DefaultsConstants.DEFAULT_DAYS_FORWARD
  }

  private var calendars: [EKCalendar]? {
    if let ids = defaults?.arrayForKey(DefaultsConstants.CALENDARS_KEY) as? [String] {
      if ids.count > 0 {
        return ids.map { self.store.calendarWithIdentifier($0) }
      }
    }
    return nil
  }

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView?.dataSource = self
      tableView?.layoutMargins = UIEdgeInsetsZero
    }
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    fetchEvents(completionHandler)
  }

  private func updatePreferredContentSize() {
    preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(max(events.count, 1)) * 44.0)
  }

  private func reloadDataWithCompletion(completionHandler: (NCUpdateResult) -> Void, result: NCUpdateResult) {
    self.tableView.reloadData()
    self.updatePreferredContentSize()
    completionHandler(result)
  }
}

// MARK: Event Fetching

extension TodayViewController {
  private func requestAccessToEvents(completion: (Bool, NSError?) -> Void) {
    store.requestAccessToEntityType(EKEntityTypeEvent, completion: completion)
  }
  
  private func fetchEvents(completionHandler: (NCUpdateResult) -> Void) {
    self.events = EventCache.eventsFromCache()
    reloadDataWithCompletion(completionHandler, result: .NoData)
    
    requestAccessToEvents { [unowned self] granted, error in
      if granted {
        var updateResult = NCUpdateResult.NoData
        let endDate = DatesHelper.startOfDayForDaysFromNow(self.daysForward)
        let predicate = self.store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: self.calendars)
        if let ekEvents = self.store.eventsMatchingPredicate(predicate) as? [EKEvent] {
          let newEvents = ekEvents.map { Event(ekEvent: $0) }
          updateResult = newEvents != self.events ? .NewData : .NoData
          self.events = newEvents
        } else {
          updateResult = .NoData
          self.events = []
        }
        EventCache.cacheEvents(self.events)
        self.reloadDataWithCompletion(completionHandler, result: updateResult)
      } else {
        completionHandler(.Failed)
      }
    }
  }
}

// MARK: UITableViewDataSource

extension TodayViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return max(events.count, 1)
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if events.count > 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventCell
      cell.event = events[indexPath.row]
      return cell
    } else {
      return tableView.dequeueReusableCellWithIdentifier("EmptyStateCell") as! EmptyStateCell
    }
  }
}
