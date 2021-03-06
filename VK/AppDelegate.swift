//
//  AppDelegate.swift
//  VK
//
//  Created by  Sergei on 20.12.2020.
//

import UIKit
import PromiseKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    PromiseKit.conf.Q.map = .global()

    let navigationBar = UINavigationBar.appearance()
    navigationBar.tintColor = Constants.colors.vkWhite
    navigationBar.barTintColor = Constants.colors.vkBlue
    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.vkWhite!]

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running,
    // this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
