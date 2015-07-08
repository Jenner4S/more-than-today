//
//  CALayer+borderUIColor.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/8/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {

  func setBorderUIColor(color: UIColor!){
    if let color = color {
      self.borderColor = color.CGColor
    }
  }

  func borderUIColor() -> UIColor! {
    return UIColor(CGColor: self.borderColor)
  }
}
