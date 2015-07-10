//
//  IntroViewController.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 7/6/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)

  @IBOutlet weak var thanksLabel: UILabel!
  @IBOutlet weak var notificationCenterLabel: UILabel!
  @IBOutlet weak var dismissButton: UIButton!

  let transitionManager = IntroDismissTransition()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.localize()
  }

  private func localize() {
    thanksLabel.text = NSLocalizedString("intro_thanks", tableName: "Settings", comment: "Thanks for downloading app")
    notificationCenterLabel.text = NSLocalizedString("intro_explanation", tableName: "Settings", comment: "Tell user to add to notification center and come back")
    dismissButton.titleLabel?.text = NSLocalizedString("intro_dismiss", tableName: "Settings", comment: "Title for dismiss button")
  }

  @IBAction func dismissTapped(sender: UIButton) {
    self.transitioningDelegate = self.transitionManager
    dismissViewControllerAnimated(true, completion: nil)
  }
}
