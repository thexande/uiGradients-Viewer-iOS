//
//  AppDelegate.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/27/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import UIKit
import Pulley
import GoogleMobileAds

struct ObfuscatedConstants {
    static let googleAppPubId: [UInt8] = [34, 17, 93, 37, 21, 28, 72, 23, 20, 22, 72, 127, 98, 123, 87, 94, 92, 83, 76, 113, 64, 72, 118, 83, 91, 85, 82, 31, 64, 82, 125, 106, 125, 84, 90, 86, 85, 69]
    static let exportBannerId: [UInt8] = [34, 17, 93, 37, 21, 28, 72, 23, 20, 22, 72, 127, 98, 123, 87, 94, 92, 83, 76, 113, 64, 72, 118, 83, 91, 85, 82, 78, 67, 85, 125, 100, 121, 91, 95, 83, 82, 71]
    static let testId: String = "ca-app-pub-3940256099942544/2934735716"
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator = GradientCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.root
        window?.makeKeyAndVisible()
        GADMobileAds.configure(withApplicationID: Obfuscator().reveal(key: ObfuscatedConstants.googleAppPubId))
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

