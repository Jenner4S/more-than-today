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
  private var events = [[Event]]()

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
      tableView?.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    fetchEvents(completionHandler)
  }

  private func updatePreferredContentSize() {
    let headerHeight = events.count * 42
    let eventHeight = events.reduce(0, combine: { $0 + $1.count * 44 })
    let emptyHeight = events.isEmpty ? 44 : 0
    preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(headerHeight + eventHeight + emptyHeight))
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
    store.requestAccessToEntityType(EKEntityType.Event, completion: completion)
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
          let newEvents = self.groupEvents(ekEvents.map { Event(ekEvent: $0) })
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

  private func groupEvents(events: [Event]) -> [[Event]] {
    let calendar = NSCalendar.currentCalendar()
    var grouped = [NSDate: [Event]]()
    for event in events {
      let key = calendar.startOfDayForDate(event.start)
      grouped[key] = (grouped[key] ?? []) + [event]
    }
    return grouped.values.array.sort { $0.first!.start < $1.first!.start }
  }
}

// MARK: UITableViewDataSource

extension TodayViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return max(events.count, 1)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.isEmpty ? 1 : events[section].count
  }

  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return events.isEmpty ? nil : HeaderPresenter(forDate: events[section].first!.start).title
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if events.isEmpty {
      return tableView.dequeueReusableCellWithIdentifier("EmptyStateCell") as! EmptyStateCell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventCell
      cell.event = events[indexPath.section][indexPath.row]
      return cell
    }
  }

}
