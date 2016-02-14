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
  private let TOP_INSET_CORRECTION: CGFloat = -6
  private let HEADER_HEIGHT: CGFloat = 36
  private let MAX_EVENTS = 5
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

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      tableView?.layoutMargins = UIEdgeInsetsZero
      tableView?.contentInset = UIEdgeInsets(top: TOP_INSET_CORRECTION, left: 0, bottom: 0, right: 0)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    Crittercism.enableWithAppID(CRITTERCISM_APP_ID)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    fetchEventsUsingCache(true, completionHandler: nil)
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    fetchEventsUsingCache(false, completionHandler: completionHandler)
  }

  private func updatePreferredContentSize() {
    if let tableView = tableView {
      preferredContentSize = CGSize(width: preferredContentSize.width, height: tableView.contentSize.height - TOP_INSET_CORRECTION)
    }
  }

  private func reloadDataWithCompletion(completionHandler: ((NCUpdateResult) -> Void)?, result: NCUpdateResult?) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView?.reloadData()
      self.updatePreferredContentSize()
      if let completionHandler = completionHandler, result = result {
        completionHandler(result)
      }
    })
  }
}

// MARK: Event Fetching

extension TodayViewController {
  private func requestAccessToEvents(completion: (Bool, NSError?) -> Void) {
    store.requestAccessToEntityType(EKEntityType.Event, completion: completion)
  }
  
  private func fetchEventsUsingCache(useCache: Bool, completionHandler: ((NCUpdateResult) -> Void)?) {
    if useCache {
      self.events = EventCache.eventsFromCache()
      reloadDataWithCompletion(nil, result: nil)
    }
    
    requestAccessToEvents { [weak self] granted, error in
      if let requiredSelf = self where granted {
        var updateResult = NCUpdateResult.NoData
        let endDate = DatesHelper.startOfDayForDaysFromNow(requiredSelf.daysForward)
        let predicate = requiredSelf.store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: requiredSelf.calendars)
        let ekEvents = requiredSelf.store.eventsMatchingPredicate(predicate)
        let trimmedEvents = ekEvents.count > requiredSelf.MAX_EVENTS ? Array(ekEvents[0..<requiredSelf.MAX_EVENTS]) : ekEvents
        let newEvents = requiredSelf.groupEvents(trimmedEvents.map { Event(ekEvent: $0) })
        updateResult = newEvents != requiredSelf.events ? .NewData : .NoData
        requiredSelf.events = newEvents
        EventCache.cacheEvents(requiredSelf.events)
        requiredSelf.reloadDataWithCompletion(completionHandler, result: updateResult)
      } else {
        completionHandler?(.Failed)
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
      let cell = tableView.dequeueReusableCellWithIdentifier(String(EmptyStateCell)) as! EmptyStateCell
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(String(EventCell)) as! EventCell
      cell.event = events[indexPath.section][indexPath.row]
      cell.timeWidth = longestTime
      return cell
    }
  }

}
