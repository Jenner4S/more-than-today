//
//  MainViewController.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit
import EventKit

class MainViewController: UIViewController {
  private let defaults = NSUserDefaults(suiteName: DefaultsConstants.SUITE_NAME)

  lazy private var introViewController: IntroViewController = {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let intro = storyboard.instantiateViewControllerWithIdentifier("intro") as! IntroViewController
    intro.delegate = self
    return intro
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
  @IBOutlet weak var hourFormatLabel: UILabel!  {
    didSet {
      hourFormatLabel.text = NSLocalizedString("settings_hour_format_title", tableName: "Settings", comment: "Label for 24 hour format switch")
    }
  }

  @IBOutlet weak var hourFormatSwitch: UISwitch! {
    didSet {
      if let defaults = defaults {
        let on = defaults.boolForKey(DefaultsConstants.HOURS_KEY) ?? DefaultsConstants.DEFAULT_HOURS
        hourFormatSwitch.setOn(on, animated: false)
      }
    }
  }
  @IBOutlet weak var builtByLabel: UILabel! {
    didSet {
      builtByLabel.text = NSLocalizedString("settings_built_by", tableName: "Settings", comment: "I built this!")
    }
  }
  @IBOutlet weak var versionLabel: UILabel! {
    didSet {
      let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
      let versionTemplate = NSLocalizedString("settings_version", tableName: "Settings", comment: "The current version template")
      versionLabel.text = NSString.localizedStringWithFormat(versionTemplate, currentVersion) as String
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
      presentViewController(introViewController, animated: false, completion: nil)
    }
  }

  private func didUserSeeIntro() -> Bool {
    if let defaults = defaults {
      return defaults.boolForKey(DefaultsConstants.SAW_INTRO_KEY)
    }
    return true
  }

  private func requestPermissionsIfNeeded() {
    if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) != .Authorized {
      EKEventStore().requestAccessToEntityType(EKEntityType.Event) { _, _ in }
    }
  }

  private func saveIntroSeen() {
    self.defaults?.setBool(true, forKey: DefaultsConstants.SAW_INTRO_KEY)
    self.defaults?.synchronize()
  }

  @IBAction func didChangeHourFormat(sender: UISwitch) {
    self.defaults?.setBool(sender.on, forKey: DefaultsConstants.HOURS_KEY)
    self.defaults?.synchronize()
  }

  @IBAction func didTapBuiltByAndVersion(sender: UITapGestureRecognizer) {
    UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/assafgelber")!)
  }
}

extension MainViewController: IntroDelegate {
  func introDismissed() {
    dismissViewControllerAnimated(true, completion: nil)
    self.shouldPresentIntro = false
    self.saveIntroSeen()
    self.requestPermissionsIfNeeded()
  }
}
