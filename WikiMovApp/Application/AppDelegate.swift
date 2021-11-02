// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    configureNavigationBarAppearance()
    return true
  }
  
  private func configureNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [.foregroundColor: Constants.Color.black]
    appearance.backgroundColor = Constants.Color.white
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    
    UINavigationBar.appearance().tintColor = Constants.Color.black
  }
}

