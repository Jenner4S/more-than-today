//
//  IconNavigationBar.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/1/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class IconNavigationBar: UINavigationBar {
  private let HEIGHT_INCREASE: CGFloat = 144
  private let STATUS_BAR_HEIGHT: CGFloat = 20
  private let DEFAULT_NAVBAR_HEIGHT: CGFloat = 44
  private let IMAGE_SIZE: CGFloat = 100
  private let TITLE_MARGIN_TOP: CGFloat = 8
  private let BACKGROUND_COLOR = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)

  private var calendarIcon: UIImageView!
  private var titleLabel: UILabel!

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
    self.transform = CGAffineTransformMakeTranslation(0, -HEIGHT_INCREASE)
    self.setupHeader()
  }

  private func setupHeader() {
    calendarIcon = UIImageView(image: UIImage(named: "Calendar"))
    self.addSubview(calendarIcon)

    titleLabel = UILabel()
    titleLabel.text = NSLocalizedString("settings_title", tableName: "Settings", comment: "Title in header of settings app")
    titleLabel.setNeedsLayout()
    titleLabel.layoutIfNeeded()
    self.addSubview(titleLabel)
  }

  private func updateHeaderFrames() {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let calendarX =  (screenWidth - IMAGE_SIZE) / 2
    let calendarY = HEIGHT_INCREASE + DEFAULT_NAVBAR_HEIGHT
    calendarIcon.frame = CGRect(x: calendarX, y: calendarY, width: IMAGE_SIZE, height: IMAGE_SIZE)

    let titleSize = titleLabel.intrinsicContentSize()
    let titleX = (screenWidth - titleSize.width) / 2
    let titleY = calendarY + IMAGE_SIZE + TITLE_MARGIN_TOP
    titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    var newSize = super.sizeThatFits(size)
    newSize.height += HEIGHT_INCREASE
    return newSize
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    for (var sub) in self.subviews as! [UIView] {
      if NSStringFromClass(sub.classForCoder) == "_UINavigationBarBackground" {
        let y: CGFloat = HEIGHT_INCREASE - STATUS_BAR_HEIGHT
        let height: CGFloat = HEIGHT_INCREASE + DEFAULT_NAVBAR_HEIGHT + STATUS_BAR_HEIGHT
        sub.frame = CGRect(x: 0, y: y, width: self.frame.width, height: height)
        sub.backgroundColor = BACKGROUND_COLOR
      }
    }

    self.updateHeaderFrames()
  }
}