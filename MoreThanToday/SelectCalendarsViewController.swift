//
//  SelectCalendarsViewController.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/17/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class SelectCalendarsViewController: UIViewController {
  private var calendars: [EKCalendar]!
  private var selectedCalendars: [String]!

  private let store = EKEventStore()
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIButton! {
    didSet {
      let title = NSLocalizedString("settings_done", tableName: "Settings", comment: "Button title for done button")
      doneButton.setTitle(title, forState: .Normal)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    calendars = loadCalendars()
    selectedCalendars = getInitialValue()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setInitialSelected()
  }

  private func loadCalendars() -> [EKCalendar] {
    let calendars = store.calendarsForEntityType(EKEntityType.Event)
    return calendars.sort { $0.title.lowercaseString < $1.title.lowercaseString }
  }

  private func getInitialValue() -> [String] {
    if let calendars = defaults?.objectForKey(DefaultsConstants.CALENDARS_KEY) as? [String] {
      return calendars
    }
    return []
  }

  private func setInitialSelected() {
    for (index, calendar) in calendars.enumerate() {
      if selectedCalendars.contains(calendar.calendarIdentifier) {
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Top)
      }
    }
  }

  private func saveSelectedCalendars() {
    defaults?.setObject(selectedCalendars, forKey: DefaultsConstants.CALENDARS_KEY)
    defaults?.synchronize()
  }
}

// MARK: TableView Delegate & Data Source

extension SelectCalendarsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return calendars.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Option Cell") as! OptionCell
    let calendar = calendars[indexPath.row]
    cell.setTitle(calendar.title)
    return cell
  }
}

extension SelectCalendarsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let calendarId = calendars[indexPath.row].calendarIdentifier
    selectedCalendars.append(calendarId)
    saveSelectedCalendars()
  }

  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    let calendarId = calendars[indexPath.row].calendarIdentifier
    if let calendarIndex = selectedCalendars.indexOf(calendarId) {
      selectedCalendars.removeAtIndex(calendarIndex)
      saveSelectedCalendars()
    }
  }
}
