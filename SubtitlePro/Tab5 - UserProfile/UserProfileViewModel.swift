//
//  UserProfileViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

extension Int {
	func countString() -> String {
		if self < 1_000 {
			return "\(self)"
		} else if self < 1_000_000 {
			let quotient = Float(self) / 1_000.0
			let quotientStr = String(format: "%.1f", quotient)
			return quotientStr + "K"
		} else {
			let quotient = Float(self) / 1_000_000
			let quotientStr = String(format: "%.1f", quotient)
			return quotientStr + "M"
		}
	}
}

class UserProfileViewModel {
	
	private var user: User? {
		didSet {
			if let _ = user {
				if isCurrentUser {
					self.items = [.posts, .followers, .following, .editProfile, .signOut]
				} else {
					self.items = [.posts, .followers, .following]
				}
			} else {
				self.items = [.login]
			}
		}
	}
	
	var userValid: Bool {
		return self.user != nil ? true : false
	}
	
	func setUser(user: User?) {
		self.user = user
	}
	
	private var items: [ProfileMenuItem] = [] {
		didSet {
			menuItemChanged?(items)}
	}
	
	var numberOfItems: Int { return items.count }
	
	var username: String { return user?.username ?? "" }
	var profileImageURL: String { return user?.profileImageURL ?? "" }
	
	var postCount: String { return "0" }
	var followingCount: String { return "0" }
	var followerCount: String { return "0" }
	
	var isCurrentUser: Bool {
		guard let currentUserId = User.currentUser?.id else { return false }
		guard let userId = user?.id else { return false }
		return currentUserId == userId
	}
	
	var menuItemChanged: (([ProfileMenuItem]) -> ())?
	
	func item(at index: Int) -> ProfileMenuItem? {
		guard index < items.count else { return nil }
		return items[index]
	}
	
	func viewModel(for index: Int) -> ProfileContentCellViewModel? {
		guard let item = item(at: index) else { return nil }
		return ProfileContentCellViewModel(menuItem: item)
	}
	
	var reloadPage: ((String) -> ())?
	
	/* New way of storing images
		 Using Aliyun Object storage
  */
	func upload(image: UIImage, completion: @escaping ((Bool) -> ())) {
		
		AliyunOSS.oss.putObject(image: image, quality: 0.1, destinationDir: AliyunOSS.Dir.profileImages) { (success, message, objectKey)  in
			DispatchQueue.main.async {
				print("success:", success)
				completion(success)
				InfoView.show(message: success ? "上传成功" : "上传失败", success: success)
				if success {
					self.user?.profileImageURL = objectKey
					User.currentUser?.profileImageURL = objectKey
					updateSavedUserInfo()
				}
			}
		}

	}
	
	// Old way of storing images
	// No longer using anymore
	func uploadImage(data: Data, completion: ((Bool) -> ())?) {
		Storage.storage().uploadProfileImage(with: data) { (success, info, message) in
			if success {
				guard let dict = info,
							let profileImageURL = dict["profileImageURL"] as? String else {
								return
				}
				User.currentUser?.profileImageURL = profileImageURL
				
				if let image = UIImage(data: data) {
					imageCache[profileImageURL] = image
				}
				
				self.user = User.currentUser
				updateSavedUserInfo()
				self.reloadPage?(profileImageURL)
			}
			completion?(success)
			InfoView.show(message: message, success: success)
		}
	}
}
