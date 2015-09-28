//
//  IntroDismissTransition.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/8/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class IntroDismissTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return AnimationUtilities.DURATION
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView()
    let introVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! IntroViewController
    let mainVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MainViewController
    let duration = self.transitionDuration(transitionContext)

    container!.addSubview(mainVC.view)
    container!.addSubview(introVC.view)

    mainVC.titleLabel.alpha = 0
    mainVC.buttonsContainer.alpha = 0

    UIView.animateWithDuration(duration * 0.5, animations: {
      introVC.view.alpha = 0
    })
    UIView.animateWithDuration(duration * 0.5, delay: duration * 0.5, options: [], animations: {
      mainVC.buttonsContainer.alpha = 1
      mainVC.titleLabel.alpha = 1
    }, completion: { finished in
      transitionContext.completeTransition(finished)
    })
  }

  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
}
