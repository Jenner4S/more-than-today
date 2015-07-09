//
//  ShadowlessNavigationBar.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 7/9/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class ShadowlessNavigationBar: UINavigationBar {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  private func setup() {
    self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.shadowImage = UIImage()
  }
}
