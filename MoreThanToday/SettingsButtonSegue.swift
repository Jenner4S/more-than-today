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
  var fadeViews = [UIView]()

  override func perform() {
    let sourceVC = self.sourceViewController 
    let destinationVC = self.destinationViewController 
    let duration = AnimationUtilities.DURATION

    let transformView = UIView(frame: senderView.frame)
    transformView.backgroundColor = senderView.backgroundColor
    senderView.superview!.addSubview(transformView)

    let sourceFrame = AnimationUtilities.frameInWindowOfView(transformView)
    var targetFrame = AnimationUtilities.frameInWindowOfView(targetView)

    targetFrame.origin.y += 64
    targetFrame.size.height -= 64

    UIView.animateWithDuration(duration * 0.5, animations: {
      transformView.transform = AnimationUtilities.transformFromFrame(sourceFrame, toFrame: targetFrame)
    }, completion: { _ in
      let mockDestinationView = AnimationUtilities.getViewSnapshot(destinationVC.view)
      sourceVC.view.addSubview(mockDestinationView)
      mockDestinationView.alpha = 0
      UIView.animateWithDuration(duration * 0.5, animations: {
        mockDestinationView.alpha = 1
      }, completion: { _ in
        sourceVC.presentViewController(destinationVC, animated: false, completion: {
          transformView.removeFromSuperview()
          mockDestinationView.removeFromSuperview()
        })
      })
    })
  }
}
