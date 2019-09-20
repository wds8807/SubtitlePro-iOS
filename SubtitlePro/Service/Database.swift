//
//  Database.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/26/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

final class Database {
	
	private init() { }
	
	static func database() -> Database {
		return Database()
	}
	
	private let fetchUserFromIdPath = "http://47.96.148.175/app/SubtitlePro/Database/fetchUserFromId.php"
	private let fetchUserFromUsernamePath = "http://47.96.148.175/app/SubtitlePro/Database/fetchUserFromUsername.php"
	
	func fetchUser(from id: Int, _ completion: @escaping ((User) -> ())) {
		
		guard let url = URL(string: fetchUserFromIdPath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "id=\(id)"
		request.httpBody = body.data(using: .utf8)
		
//		Service.shared.makeRequest(with: request) { (success, info, _) in
//			guard let userDict = info, let idStr = userDict["id"] as? String, let id = Int(idStr) else { return }
//			let user = User(id: id, dictionary: userDict)
//			completion(user)
//		}
	}
	
	func fetchUser(from username: String, _ completion: @escaping ((User) -> ())) {
		
		guard let url = URL(string: fetchUserFromUsernamePath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "username=\(username)"
		request.httpBody = body.data(using: .utf8)
		
//		Service.shared.makeRequest(with: request) { (success, info, _) in
//			guard let userDict = info, let idStr = userDict["id"] as? String, let id = Int(idStr) else { return }
//			let user = User(id: id, dictionary: userDict)
//			completion(user)
//		}
	}
	
	func testUser(from username: String, _ completion: @escaping ((User) -> ())) {
		
		guard let url = URL(string: fetchUserFromUsernamePath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "username=\(username)"
		request.httpBody = body.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else { return }
			
			do {
				let user = try JSONDecoder().decode(User.self, from: data)
				completion(user)
			} catch {
				print("Json decode error.")
			}
		}
		
		task.resume()
	}
	
	
}
