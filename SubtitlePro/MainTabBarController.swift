//
//  ViewController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
	
//	lazy var uploadsSession: URLSession = {
//		let config = URLSessionConfiguration.background(withIdentifier: "bgUpload")
//		config.allowsCellularAccess = true
//		config.isDiscretionary = false
//		config.networkServiceType = .video
//		let session =  URLSession(configuration: config, delegate: self, delegateQueue: nil)
//		return session
//	}()
	
	//let uploadService = UploadService()

	override func viewDidLoad() {
		super.viewDidLoad()
		//self.delegate = self
		tabBar.barTintColor = .white
		tabBar.tintColor = .themeGreen
		
		if let userDict = UserDefaults.standard.value(forKey: Keys.savedUser) as? [String: Any] {
			User.currentUser = User(dictionary: userDict)
			print("User info found.")
		}
		
		setupViewControllers()
	}
	
	func setupViewControllers() {
		
		let home = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
		let homeNav = template(image: UIImage(named: "home50"), rootViewController: home)
		
		let following = FollowingController(collectionViewLayout: UICollectionViewFlowLayout())
		let followingNav = template(image: UIImage(named: "heart50"), rootViewController: following)
		
		let library = FilesController(collectionViewLayout: UICollectionViewFlowLayout())
		let libraryNav = template(image: UIImage(named: "files50"), rootViewController: library)
		
		let activity = ActivityController(collectionViewLayout: UICollectionViewFlowLayout())
		let activityNav = template(image: UIImage(named: "history"), rootViewController: activity)
		
		let userProfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
		let viewModel = UserProfileViewModel()
		viewModel.setUser(user: User.currentUser)
		userProfile.viewModel = viewModel
		
		let userProfileNav = template(image: UIImage(named: "me50"), rootViewController: userProfile, barColor: .themeLight)
		
		viewControllers = [homeNav, followingNav, libraryNav, activityNav, userProfileNav]
		
		guard let items = tabBar.items else { return }
		let titles = ["Home", "Following", "Library", "Activity", "User"]
		
		for i in 0..<items.count {
			items[i].title = titles[i]
		}
		
		_ = home.view
		_ = following.view
		_ = library.view
		_ = activity.view
		_ = userProfile.view
	}
	
	fileprivate func template(image: UIImage?, rootViewController: UIViewController = UIViewController(), barColor: UIColor = .themeGreen) -> ScrollingNavigationController {
		
		let navController = ScrollingNavigationController(rootViewController: rootViewController)
		
		navController.navigationBar.barStyle = .blackTranslucent
		navController.tabBarItem.image = image
		navController.navigationBar.isTranslucent = false
		navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
		navController.navigationBar.barTintColor = barColor
		navController.navigationBar.tintColor = .white
		return navController
	}
}

extension UINavigationController {
	
	func configureToTheme() {
		self.navigationBar.barStyle = .blackTranslucent
		self.navigationBar.isTranslucent = false
		self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
		self.navigationBar.barTintColor = .themeGreen
		self.navigationBar.tintColor = .white
	}
}

//extension MainTabBarController: URLSessionDataDelegate {
	
//	func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//		if let _ = error {
//			InfoView.show(message: "上传失败，请重新上传", success: false)
//		}
//
//
//	}
	
//	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//
//		do {
//			let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
//			guard let parsedJson = json else { return }
//
//			if let status = parsedJson["status"] as? String {
//				if status == "200" {
//					InfoView.show(message: "恭喜，上传成功！", success: true)
//				} else if status == "300" {
//					InfoView.show(message: "抱歉，上传失败，请再试一次", success: false)
//				}
//			}
//
//			if let local_tmp = parsedJson["local_tmp"] as? String {
//
//				print(local_tmp)
//
//				do {
//					try FileManager.default.removeItem(atPath: local_tmp)
//				} catch {
//					print("failed to remove local_tmp.")
//				}
//			}
//
//		} catch {
//			InfoView.show(message: "返回数据格式错误", success: false)
//		}
//
//
//
//	}
//
//	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//
//		let percentage = Float(totalBytesSent)/Float(totalBytesExpectedToSend) * 100
//
//		if floor(percentage) - percentage < 0.00001 {
//			let str = String(format: "%.2f", percentage) + "% sent"
//			print(str)
//		}
//
//	}
//
//}
//
//
//extension MainTabBarController: URLSessionDelegate {
//
//	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//		DispatchQueue.main.async {
//			print("Finished!")
//
//			if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//				let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//				appDelegate.backgroundSessionCompletionHandler = nil
//				completionHandler()
//			}
//		}
//	}
//}
