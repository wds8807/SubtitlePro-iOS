//
//  BaseController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/31/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class BaseController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
	
	lazy var menu: Menu = {
		let menu = Menu()
		menu.delegate = self
		return menu
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		collectionView?.alwaysBounceVertical = true
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
	}
	
	override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		if let navController = navigationController as? ScrollingNavigationController {
			navController.showNavbar(animated: true)
		}
		return true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let top: CGFloat = 0
		// Pending modification
		collectionView?.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	override var prefersStatusBarHidden: Bool { return false }
	
	func setupNavBar() {
		setNeedsStatusBarAppearanceUpdate()
		if let navigationController = navigationController as? ScrollingNavigationController {
			guard let cv = self.collectionView else { return }
			navigationController.followScrollView(cv, delay: 0, scrollSpeedFactor: 2)
		}
	}
	
	func setupBarButtonItems(title: String) {
		navigationItem.title = title
		navigationController?.delegate = self
		
		let callbackButton = UIBarButtonItem(title: "Callback", style: .plain, target: self, action: #selector(triggerCallback))

		let composeButton = UIBarButtonItem(image: UIImage(named: "compose48"), style: .plain, target: self, action: #selector(handleCompose))
		let searchButton = UIBarButtonItem(image: UIImage(named: "search_new40"), style: .plain, target: self, action: #selector(handleSearch))
		let cameraButton = UIBarButtonItem(image: UIImage(named: "record56"), style: .plain, target: self, action: #selector(handleCamera))
		
		
		searchButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		cameraButton.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
		navigationItem.rightBarButtonItems = [composeButton, searchButton, cameraButton]
		navigationItem.leftBarButtonItem = callbackButton
		navigationController?.navigationBar.tintColor = .white
	}
	
	@objc func triggerCallback() {
		AliyunOSS.oss.triggerCallback()
	}
	
	@objc func handleSearch() {
		print("Handling serach...")
	}
	
	@objc func handleCompose() {
		if let _ = User.currentUser {
			menu.show(items: [MenuItem.fromPhotoLibrary, MenuItem.fromAppLibrary, MenuItem.cancel])
		} else {
			menu.show(items: [MenuItem.login, MenuItem.cancel])
		}
	}
	
	@objc func handleCamera() {
		print("Handling camera...")
	}
	
	@objc func doNothing() {
		print("tapping space")
	}
	
}

extension BaseController: MenuDelegate {
	
	func menu(_ menu: Menu, didSelect item: String) {
		
		if item == MenuItem.login { handleLogin() }
		
		else if item == MenuItem.fromPhotoLibrary { selectMedia(from: .photoLibrary) }
		
		else if item == MenuItem.fromAppLibrary { selectMedia(from: .appLibrary) }

	}
	
	func menu(_ menu: Menu, didTapBlackView blackView: UIView) {
		menu.handleDismiss2()
	}
	
	func selectMedia(from location: FetchLocation) {
		
		let viewModel = MediaSelectorViewModel()
		viewModel.purpose = .toUpload
		viewModel.fetchLocation = location
		let mediaSelector = MediaSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
		mediaSelector.delegate = self
		mediaSelector.viewModel = viewModel
		let navController = UINavigationController(rootViewController: mediaSelector)
		navController.navigationBar.isTranslucent = false
		navController.navigationBar.barTintColor = .gray64
		navController.navigationBar.barStyle = .black
		navController.navigationBar.tintColor = .white
		present(navController, animated: true)
	}
	
	func handleLogin() {
		let loginController = LoginController()
		loginController.viewModel = LoginViewModel()
		let navController = UINavigationController(rootViewController: loginController)
		self.present(navController, animated: true, completion: nil)
	}
	
}

extension BaseController: MediaSelectorDelegate {
	
	func didInitiateUpload() {
		print("did initiate upload")
	}
	
	func importFinished(success: Bool) {
		// do nothing
	}
}

