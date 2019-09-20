//
//  User.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

struct User: Decodable {
	
	static var currentUser: User?
	
	let id: Int
	let username: String
	var email: String
	var profileImageURL: String
	var isFollowed = false
	
	init(dictionary: [String: Any]) {
		if let id = dictionary["id"] as? Int {
			self.id = id
		} else if let idStr = dictionary["id"] as? String, let id = Int(idStr) {
			self.id = id
		} else {
			self.id = -1
		}
		self.username = dictionary["username"] as? String ?? ""
		self.email = dictionary["email"] as? String ?? ""
		self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
	}
}

extension User {
	func dictionary() -> [String: Any] {
		var dict = [String: Any]()
		dict["id"] = self.id
		dict["username"] = self.username
		dict["email"] = self.email
		dict["profileImageURL"] = self.profileImageURL
		print(dict)
		return dict
	}
}
