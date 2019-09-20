//
//  AppDelegate.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import Foundation

func updateSavedUserInfo() {
	UserDefaults.standard.set(User.currentUser?.dictionary(), forKey: Keys.savedUser)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var orientationLock = UIInterfaceOrientationMask.portrait
	var window: UIWindow?
	var backgroundSessionCompletionHandler: (() -> Void)?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		
		let mainTabBarController = MainTabBarController()
		window?.rootViewController = mainTabBarController

		return true
	}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return self.orientationLock
	}

	func applicationWillResignActive(_ application: UIApplication) {

	}

	func applicationDidEnterBackground(_ application: UIApplication) {

	}

	func applicationWillEnterForeground(_ application: UIApplication) {

	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		print("Launching app in the background.")
		backgroundSessionCompletionHandler = completionHandler
	}

}

