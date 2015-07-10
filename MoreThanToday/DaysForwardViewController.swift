//
//  DaysForwardViewController.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/17/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class DaysForwardViewController: UIViewController {
  private var selectedValue: Int!
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIButton! {
    didSet {
      doneButton.titleLabel?.text = NSLocalizedString("settings_done", tableName: "Settings", comment: "Button title for done button")
    }
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectedValue = getInitialValue()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setInitialSelected()
  }

  private func getInitialValue() -> Int {
    if let days = defaults?.integerForKey(DefaultsConstants.DAYS_FORWARD_KEY) {
      return days > 0 ? days : DefaultsConstants.DEFAULT_DAYS_FORWARD
    }
    return DefaultsConstants.DEFAULT_DAYS_FORWARD
  }

  private func setInitialSelected() {
    for (index, option) in enumerate(DAYS_FORWARD_OPTIONS) {
      if selectedValue == option.value {
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Top)
        break
      }
    }
  }
}

// MARK: TableView Delegate & Data Source

extension DaysForwardViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DAYS_FORWARD_OPTIONS.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Option Cell") as! OptionCell
    let option = DAYS_FORWARD_OPTIONS[indexPath.row]
    cell.setTitle(option.title)
    return cell
  }
}

extension DaysForwardViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let value = DAYS_FORWARD_OPTIONS[indexPath.row].value
    defaults?.setInteger(value, forKey: DefaultsConstants.DAYS_FORWARD_KEY)
    defaults?.synchronize()
    selectedValue = value
  }
}
