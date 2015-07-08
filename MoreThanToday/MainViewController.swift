//
//  MainViewController.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)

  lazy private var introViewController: IntroViewController = {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier("intro") as! IntroViewController
  }()

  @IBOutlet weak var buttonsContainer: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.showIntroIfNeeded()
  }

  private func showIntroIfNeeded() {
    if shouldPresentIntro() {
      presentViewController(introViewController, animated: false) {
        self.defaults?.setBool(true, forKey: DefaultsConstants.SAW_INTRO_KEY)
        self.defaults?.synchronize()
      }
    }
  }

  private func shouldPresentIntro() -> Bool {
    if let defaults = defaults {
      return !defaults.boolForKey(DefaultsConstants.SAW_INTRO_KEY)
    }
    return false
  }
}
