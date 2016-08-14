//
//  DateHeader.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 10/4/15.
//  Copyright © 2015 Gelber, Assaf. All rights reserved.
//

import UIKit

class DateHeader: UIView {
  private var titleLabel: UILabel!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  convenience init() {
    self.init(frame: CGRectZero)
  }

  private func setup() {
    titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFontOfSize(12)
    titleLabel.textColor = UIColor.whiteColor()
    
    self.addSubview(titleLabel)
    setupConstraints()
  }

  private func setupConstraints() {
    let views = ["title": titleLabel]
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[title]|", options: [], metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[title]|", options: [], metrics: nil, views: views)
    self.addConstraints(hConstraints + vConstraints)
  }

  func setDate(date: NSDate) {
    let presenter = HeaderPresenter(forDate: date)
    titleLabel.text = presenter.title.uppercaseString
  }
}