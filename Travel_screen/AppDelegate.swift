//
//  AppDelegate.swift
//  Travel_screen
//
//  Created by Dmytro Maniakhin on 12.06.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        let backButtonBackgroundImage = UIImage(named: "NavigationBar_BackButton")
//        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [ViewController.self])
//        barAppearance.backIndicatorImage = backButtonBackgroundImage
//        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
//        
//        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [ViewController.self])
//        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -5), for: .default)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

