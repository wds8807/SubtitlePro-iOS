//
//  SubscriptionController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class FollowingController: BaseController {
	
	let activityIndicator: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
		aiv.hidesWhenStopped = true
		aiv.startAnimating()
		return aiv
	}()
	
	func startAnimating() {
		self.view.addSubview(activityIndicator)
		activityIndicator.center(in: view, offsetX: 0, offsetY: -50)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		collectionView?.refreshControl = refreshControl
		
		setupBarButtonItems(title: "Following")
	}
	
	@objc func handleRefresh() {
		print("Handling refresh.")
	}
}
