//
//  DoneUnwindSegue.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/10/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class DoneUnwindSegue: UIStoryboardSegue {
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
    
    senderView.alpha = 0

    sourceVC.view.insertSubview(destinationVC.view, atIndex: 0)

    let sourceFrame = AnimationUtilities.frameInWindowOfView(transformView)
    let targetFrame = AnimationUtilities.frameInWindowOfView(targetView)
    
    UIView.animateWithDuration(duration * 0.5, animations: {
      transformView.transform = AnimationUtilities.transformFromFrame(sourceFrame, toFrame: targetFrame)
      for view in self.fadeViews {
        view.alpha = 0
      }
    }, completion: { _ in
      UIView.animateWithDuration(duration * 0.5, animations: {
        transformView.alpha = 0
      }, completion: { _ in
        transformView.removeFromSuperview()
        sourceVC.dismissViewControllerAnimated(false, completion: nil)
      })
    })

  }
}