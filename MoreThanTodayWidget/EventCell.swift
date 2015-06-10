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

  lazy var timeFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = .NoStyle
    _formatter.timeStyle = .ShortStyle
    return _formatter
  }()

  lazy var dateFormatter: NSDateFormatter = {
    let _formatter = NSDateFormatter()
    _formatter.dateStyle = .ShortStyle
    _formatter.timeStyle = .NoStyle
    return _formatter
    }()

  var event: EKEvent! {
    didSet {
      updateUI()
    }
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var fromLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  @IBOutlet weak var dateDetailsContainer: UIView!
  @IBOutlet weak var spacingConstraint: NSLayoutConstraint!
  @IBOutlet weak var eventDetailsWidthConstraint: NSLayoutConstraint!

  private func updateUI() {
    if let event = self.event {
      titleLabel.text = event.title
      locationLabel.text = event.location
      dateLabel.text = dateFormatter.stringFromDate(event.startDate)
      fromLabel.text = timeFormatter.stringFromDate(event.startDate)
      toLabel.text = timeFormatter.stringFromDate(event.endDate)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let dateSize = dateDetailsContainer.frame.width
    let spacingSize = spacingConstraint.constant
    eventDetailsWidthConstraint.constant = frame.width - dateSize - spacingSize
  }
}
