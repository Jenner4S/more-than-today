//
//  EmptyStateCell.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/1/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class EmptyStateCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
  }

  private func setup() {
    self.layoutMargins = UIEdgeInsetsZero
    titleLabel.text = NSLocalizedString("no_events", tableName: "Widget", comment: "Text shown when there are no events")
  }
}