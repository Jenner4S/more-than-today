//
//  AnimationUtilities.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 7/9/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class AnimationUtilities {
  static let DURATION: NSTimeInterval = 0.5

  static func frameInWindowOfView(view: UIView) -> CGRect {
    return view.superview!.convertRect(view.frame, toView: nil)
  }

  static func transformFromFrame(source: CGRect, toFrame target: CGRect) -> CGAffineTransform {
    let scale = CGSize(width: target.width / source.width, height: target.height / source.height)
    let offset = CGPoint(x: target.midX - source.midX, y: target.midY - source.midY)
    return CGAffineTransform(a: scale.width, b: 0, c: 0, d: scale.height, tx: offset.x, ty: offset.y)
  }
}