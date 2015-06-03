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
  
  private let NINETY_DAYS = 90 * 24 * 60 * 60 // in seconds
  
  private let store = EKEventStore()
  private var events = [EKEvent]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    tableView.dataSource = self
    fetchEvents()
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
    fetchEvents()
    completionHandler(.NewData)
  }

  private func updatePreferredContentSize() {
    preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(events.count) * tableView.rowHeight)
  }
  
  private func requestAccessToEvents(completion: (Bool, NSError?) -> Void) {
    store.requestAccessToEntityType(EKEntityTypeEvent, completion: completion)
  }
  
  private func fetchEvents() {
    requestAccessToEvents { [unowned self] granted, error in
      if granted {
        let predicate = self.store.predicateForEventsWithStartDate(NSDate(), endDate: NSDate(timeIntervalSinceNow:Double(self.NINETY_DAYS)), calendars: nil)
        self.events = self.store.eventsMatchingPredicate(predicate) as! [EKEvent]
        
        self.tableView.reloadData()
        self.updatePreferredContentSize()
      }
    }
  }
}

extension TodayViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventCell
    cell.event = events[indexPath.row]
    return cell
  }
}
