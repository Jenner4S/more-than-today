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

  var event: EKEvent? {
    didSet {
      if let event = self.event {
        eventPresenter = EventPresenter(forEvent: event)
        updateUI()
      }
    }
  }

  private var eventPresenter: EventPresenter!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var fromLabel: UILabel!
  @IBOutlet weak var toLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  @IBOutlet weak var dateDetailsContainer: UIView!
  @IBOutlet weak var spacingConstraint: NSLayoutConstraint!
  @IBOutlet weak var eventDetailsWidthConstraint: NSLayoutConstraint!

  private func updateUI() {
    titleLabel.text = eventPresenter.title
    locationLabel.text = eventPresenter.location
    dateLabel.text = eventPresenter.date
    fromLabel.text = eventPresenter.startTime
    toLabel.text = eventPresenter.endTime
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let dateSize = dateDetailsContainer.frame.width
    let spacingSize = spacingConstraint.constant
    eventDetailsWidthConstraint.constant = frame.width - dateSize - spacingSize
  }
}
