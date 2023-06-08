//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let weatherViewController = WeatherViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = weatherViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

