//
//  Auth.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/26/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

struct Keys {
	static let savedUser = "savedUser"
}

final class Auth {
	
	static func auth() -> Auth {
		return Auth()
	}
	
	private init() { }
	
	private let loginPath = "http://47.96.148.175/app/SubtitlePro/Auth/Login.php"
	private let signupPath = "http://47.96.148.175/app/SubtitlePro/Auth/Signup.php"
	private let checkUsernamePath = "http://47.96.148.175/app/SubtitlePro/Auth/CheckUsername.php"
	

	fileprivate func makeRequest(with request: URLRequest, completion: ((_ success: Bool, _ info: [String: Any]?, _ message: String) -> ())? = nil) {
	
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in

			// Could not connect to internet
			if let _ = error {
				DispatchQueue.main.async {
					completion?(false, nil, "无法连接服务器")
					return
				}
			}
			
			// Connected to internet
			guard let data = data else { return }
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
				
				guard let parsedJson = json else { return }
				
				DispatchQueue.main.async {
					if let status = parsedJson["status"] as? String, status != "200" {
						completion?(false, parsedJson, parsedJson["message"] as? String ?? "")
					} else {
						completion?(true, parsedJson, parsedJson["message"] as? String ?? "")
					}
				}
				
			} catch {
				DispatchQueue.main.async {
					completion?(false, nil, error.localizedDescription)
				}
			}
			}.resume()
	}
	
	func login(username: String, password: String, completion: ((_ success: Bool, _ info: [String: Any]?, _ message: String) -> ())? = nil) {
		
		guard let url = URL(string: loginPath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "username=\(username.lowercased())&password=\(password)"
		request.httpBody = body.data(using: .utf8)
		
		
		makeRequest(with: request) { (success, info, message) in
			
			if let dict = info {
				User.currentUser = User(dictionary: dict)
				updateSavedUserInfo()
			}

			completion?(success, info, message)
		}
		
	}
	
	func checkUsername(username: String, _ completion: @escaping ((_ userFound: Bool?, _ message: String?) -> ())) {
		guard let url = URL(string: checkUsernamePath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "username=\(username.lowercased())"
		request.httpBody = body.data(using: .utf8)
		
		makeRequest(with: request) { (success, info, message) in
			if let dict = info, let codeStr = dict["status"] as? String, let code = Int(codeStr) {
				print(code)
				if code == 200 {
					completion(true, "")
				} else {
					completion(false, "")
				}
			} else {
				completion(nil, "网络异常")
			}
		}
	}
	
	func signup(username: String, email: String, password: String, completion: ((_ success: Bool, _ info: [String: Any]?, _ message: String) -> ())? = nil) {
		
		guard let url = URL(string: signupPath) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let body = "username=\(username.lowercased())&email=\(email.lowercased())&password=\(password)"
		request.httpBody = body.data(using: .utf8)
		
		makeRequest(with: request) { (success, info, message) in
			if let dict = info {
				User.currentUser = User(dictionary: dict)
				updateSavedUserInfo()
			}
			completion?(success, info, message)
		}
		
	}
	
}


