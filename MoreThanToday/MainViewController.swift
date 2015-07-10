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

  private var shouldPresentIntro = false

  @IBOutlet weak var buttonsContainer: UIView!
  @IBOutlet weak var daysForwardButton: BorderButton! {
    didSet {
      let title = NSLocalizedString("settings_days_forward_button", tableName: "Settings", comment: "Button title for days forward setting")
      daysForwardButton.setTitle(title, forState: .Normal)
    }
  }
  @IBOutlet weak var selectCalendarsButton: BorderButton! {
    didSet {
      let title = NSLocalizedString("settings_select_calendars_button", tableName: "Settings", comment: "Button title for calendars setting")
      selectCalendarsButton.setTitle(title, forState: .Normal)
    }
  }
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.text = NSLocalizedString("settings_title", tableName: "Settings", comment: "Main title for settings app")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.shouldPresentIntro = !self.didUserSeeIntro()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    self.showIntroIfNeeded()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let segue = segue as? SettingsButtonSegue {
      segue.senderView = sender as! UIView
      segue.targetView = self.view
    }
  }

  @IBAction func unwindFromViewController(segue: UIStoryboardSegue) { }

  override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
    let targetVC = toViewController as! MainViewController
    let segue = DoneUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
    switch fromViewController {
    case let sourceVC as DaysForwardViewController:
      segue.senderView = sourceVC.tableView
      segue.targetView = targetVC.daysForwardButton
      segue.fadeViews.append(sourceVC.doneButton)
      return segue
    case let sourceVC as SelectCalendarsViewController:
      segue.senderView = sourceVC.tableView
      segue.targetView = targetVC.selectCalendarsButton
      segue.fadeViews.append(sourceVC.doneButton)
      return segue
    default:
      return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
  }

  private func showIntroIfNeeded() {
    if shouldPresentIntro {
      presentViewController(introViewController, animated: false) {
        self.shouldPresentIntro = false
        self.defaults?.setBool(true, forKey: DefaultsConstants.SAW_INTRO_KEY)
        self.defaults?.synchronize()
      }
    }
  }

  private func didUserSeeIntro() -> Bool {
    if let defaults = defaults {
      return defaults.boolForKey(DefaultsConstants.SAW_INTRO_KEY)
    }
    return true
  }
}
