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
  private var events = [EKEvent]()

  private var daysForward: Int {
    if let days = defaults?.integerForKey(DefaultsConstants.DAYS_FORWARD_KEY) {
      return days > 0 ? days : DefaultsConstants.DEFAULT_DAYS_FORWARD
    }
    return DefaultsConstants.DEFAULT_DAYS_FORWARD
  }

  private var calendars: [EKCalendar]? {
    if let ids = defaults?.arrayForKey(DefaultsConstants.CALENDARS_KEY) as? [String] {
      if ids.count > 0 {
        var calendars = [EKCalendar]()
        for identifier in ids {
          calendars.append(store.calendarWithIdentifier(identifier))
        }
        return calendars
      }
      return nil
    }
    return nil
  }

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      if tableView != nil {
        setupTableView()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchEvents()
  }

  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    fetchEvents()
    completionHandler(.NewData)
  }

  private func updatePreferredContentSize() {
    preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(max(events.count, 1)) * 44.0)
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.layoutMargins = UIEdgeInsetsZero
  }

  private func requestAccessToEvents(completion: (Bool, NSError?) -> Void) {
    store.requestAccessToEntityType(EKEntityTypeEvent, completion: completion)
  }

  private func fetchEvents() {
    self.events = EventCache.eventsFromCache()

    requestAccessToEvents { [unowned self] granted, error in
      if granted {
        let endDate = DatesHelper.startOfDayForDaysFromNow(self.daysForward)
        let predicate = self.store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: self.calendars)
        if let events = self.store.eventsMatchingPredicate(predicate) as? [EKEvent] {
          self.events = events
          EventCache.cacheEvents(events)
        } else {
          self.events = []
        }

        self.tableView.reloadData()
        self.updatePreferredContentSize()
      }
    }
  }
}

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
