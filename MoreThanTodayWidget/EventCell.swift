//
//  EventCell.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit
import Foundation

class EventCell: UITableViewCell {

  var event: Event? {
    didSet {
      if let event = self.event {
        eventPresenter = EventPresenter(forEvent: event)
        updateUI()
      }
    }
  }

  var timeWidth: CGFloat {
    set {
      timeWidthConstraint.constant = newValue
    }
    get {
      return timeWidthConstraint.constant
    }
  }

  private var eventPresenter: EventPresenter!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var fromLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var timeWidthConstraint: NSLayoutConstraint!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    self.layoutMargins = UIEdgeInsetsZero
  }

  private func updateUI() {
    titleLabel.text = eventPresenter.title
    locationLabel.text = eventPresenter.location

    if event?.allDay == true {
      fromLabel.text = EventPresenter.ALL_DAY
      toLabel.text = eventPresenter.numberOfDays
    } else {
      fromLabel.text = eventPresenter.startTime
      toLabel.text = eventPresenter.endTime
    }
  }
}
