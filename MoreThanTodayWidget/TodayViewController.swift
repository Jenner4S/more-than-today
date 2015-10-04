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
  private let TOP_INSET_CORRECTION = CGFloat(-6)
  private let HEADER_HEIGHT = CGFloat(36)
  private let TIME_FONT = UIFont.systemFontOfSize(12)

  private let store = EKEventStore()
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)
  private var longestTime: CGFloat = 0
  private var events = [[Event]]() {
    didSet {
      let eventList = events.reduce([], combine: +)
      longestTime = EventPresenter.longestSizeForEvents(eventList, inFont: TIME_FONT)
    }
  }

  private var daysForward: Int {
    if let days = defaults?.integerForKey(DefaultsConstants.DAYS_FORWARD_KEY) {
      return days > 0 ? days : DefaultsConstants.DEFAULT_DAYS_FORWARD
    }
    return DefaultsConstants.DEFAULT_DAYS_FORWARD
  }

  private var calendars: [EKCalendar]? {
    if let ids = defaults?.arrayForKey(DefaultsConstants.CALENDARS_KEY) as? [String] {
      if ids.count > 0 {
        return ids.map { self.store.calendarWithIdentifier($0)! }
      }
    }
    return nil
  }

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView?.layoutMargins = UIEdgeInsetsZero
      tableView?.contentInset = UIEdgeInsets(top: TOP_INSET_CORRECTION, left: 0, bottom: 0, right: 0)
    }
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    fetchEvents(completionHandler)
  }

  private func updatePreferredContentSize() {
    preferredContentSize = CGSize(width: preferredContentSize.width, height: tableView.contentSize.height - TOP_INSET_CORRECTION)
  }

  private func reloadDataWithCompletion(completionHandler: ((NCUpdateResult) -> Void)?, result: NCUpdateResult?) {
    self.tableView.reloadData()
    self.updatePreferredContentSize()
    if completionHandler != nil {
      completionHandler!(result!)
    }
  }
}

// MARK: Event Fetching

extension TodayViewController {
  private func requestAccessToEvents(completion: (Bool, NSError?) -> Void) {
    store.requestAccessToEntityType(EKEntityType.Event, completion: completion)
  }
  
  private func fetchEvents(completionHandler: (NCUpdateResult) -> Void) {
    self.events = EventCache.eventsFromCache()
    reloadDataWithCompletion(nil, result: nil)
    
    requestAccessToEvents { [unowned self] granted, error in
      if granted {
        var updateResult = NCUpdateResult.NoData
        let endDate = DatesHelper.startOfDayForDaysFromNow(self.daysForward)
        let predicate = self.store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: self.calendars)
        let ekEvents = self.store.eventsMatchingPredicate(predicate)
        let newEvents = self.groupEvents(ekEvents.map { Event(ekEvent: $0) })
        updateResult = newEvents != self.events ? .NewData : .NoData
        self.events = newEvents
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
    return grouped.values.sort { $0.first!.start < $1.first!.start }
  }
}

// MARK: UITableViewDataSource

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return max(events.count, 1)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.isEmpty ? 1 : events[section].count
  }

  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if events.isEmpty {
      return UIView(frame: CGRectZero)
    } else {
      let header = DateHeader()
      header.setDate(events[section].first!.start)
      return header
    }
  }

  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return events.isEmpty ? CGFloat.min : HEADER_HEIGHT
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if events.isEmpty {
      return tableView.dequeueReusableCellWithIdentifier("EmptyStateCell") as! EmptyStateCell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventCell
      cell.event = events[indexPath.section][indexPath.row]
      cell.timeWidth = longestTime
      return cell
    }
  }

}
