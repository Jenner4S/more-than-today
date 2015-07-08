//
//  OptionCell.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/17/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class OptionCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!

  func setTitle(title: String) {
    titleLabel.text = title
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.accessoryType = selected ? .Checkmark : .None
  }
}
