//
//  SettingsButtonSegue.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 7/9/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class SettingsButtonSegue: UIStoryboardSegue {
  var senderView: UIView!
  var targetView: UIView!

  override func perform() {
    let sourceVC = self.sourceViewController as! UIViewController
    let destinationVC = self.destinationViewController as! UIViewController

    let transformView = UIView(frame: senderView.frame)
    transformView.backgroundColor = senderView.backgroundColor
    senderView.superview!.addSubview(transformView)

    let sourceFrame = AnimationUtilities.frameInWindowOfView(transformView)
    let targetFrame = AnimationUtilities.frameInWindowOfView(targetView)

    UIView.animateWithDuration(0.25, animations: {
      transformView.transform = AnimationUtilities.transformFromFrame(sourceFrame, toFrame: targetFrame)
    }, completion: { _ in
      destinationVC.view.alpha = 0
      sourceVC.view.addSubview(destinationVC.view)
      UIView.animateWithDuration(0.25, animations: {
        destinationVC.view.alpha = 1
      }, completion: { _ in
        transformView.removeFromSuperview()
        destinationVC.view.removeFromSuperview()
        sourceVC.navigationController?.pushViewController(destinationVC, animated: false)
      })
    })
  }
}