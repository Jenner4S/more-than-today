//
//  BorderButton.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/8/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BorderButton: UIButton {
  @IBInspectable var borderWidth: CGFloat = 1.0
  @IBInspectable var borderColor: UIColor = UIColor.blackColor()

  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context, borderColor.CGColor)
    CGContextFillRect(context, CGRect(x: 0, y: 0, width: self.bounds.width, height: borderWidth))
    CGContextFillRect(context, CGRect(x: 0, y: self.bounds.height - borderWidth, width: self.bounds.width, height: borderWidth))
  }
}