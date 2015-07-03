//
//  AppDelegate.swift
//  MoreThanToday
//
//  Created by Gelber, Assaf on 6/2/15.
//  Copyright (c) 2015 Gelber, Assaf. All rights reserved.
//

import UIKit
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    if EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) != .Authorized {
      EKEventStore().requestAccessToEntityType(EKEntityTypeEvent) { _, _ in }
    }
    return true
  }
}

