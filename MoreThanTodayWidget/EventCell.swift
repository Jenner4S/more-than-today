//
//  EventCell.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit
import Foundation
import EventKit

class EventCell: UITableViewCell {
  
  lazy var formatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = NSDateFormatterStyle.ShortStyle
    _formatter.timeStyle = NSDateFormatterStyle.ShortStyle
    return _formatter
  }()
  
  var event: EKEvent! {
    didSet {
      updateUI()
    }
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var fromLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  private func updateUI() {
    if let event = self.event {
      titleLabel.text = event.title
      locationLabel.text = event.location
      fromLabel.text = formatter.stringFromDate(event.startDate)
      toLabel.text = formatter.stringFromDate(event.endDate)
    }
  }
}