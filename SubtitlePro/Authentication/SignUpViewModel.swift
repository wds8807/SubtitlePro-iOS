//
//  signUpViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/24/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class SignUpViewModel {
	
	private var usernameIsValid = false 
	private var emailIsValid = false
	private var passwordIsValid = false
	private var passwordsMatch = false
	private var usernameAvailable = false {
		didSet {
			print("username available:", usernameAvailable)
		}
	}
	
	var formValid: Bool {
		return usernameIsValid && emailIsValid && passwordIsValid && passwordsMatch && usernameAvailable
	}
	
	var checkerChanged: ((Status) -> ())?

	var updateUI: ((Bool) -> ())?
	
	private var usernameWarning: String = "" {
		didSet {
			warningChanged?(totalWarning) }
	}
	
	private var emailWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	private var passwordWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	var totalWarning: String { return usernameWarning + emailWarning + passwordWarning }
	
	var imageData: Data?
	
	var warningChanged: ((String) -> ())?
	
	func signUp(username: String, email: String, password: String) {
		Auth.auth().signup(username: username, email: email, password: password) { (success1, info, message) in
			// User.currentUser is already updated at this point
			
			if success1 {
				// Sign up successful
				if let data = self.imageData {
					// User selected image to upload
					Storage.storage().uploadProfileImage(with: data) { (success2, info, message) in
						if success2 {
							// Sign up successful and upload image successful
							guard let info = info, let profileImageURL = info["profileImageURL"] as? String else { return }
							User.currentUser?.profileImageURL = profileImageURL
							InfoView.show(message: "成功注册新用户 成功上传头像", success: true)
						} else {
							// Sign up successful but upload image failed
							InfoView.show(message: "成功注册新用户 头像上传失败", success: true)
						}
						self.updateUI?(true)
					}
				} else {
					// User didn't select image to upload
					InfoView.show(message: message, success: true)
					self.updateUI?(true)
				}
			} else {
				// Sign up failed
				InfoView.show(message: message, success: false)
				self.updateUI?(false)
			}
		}
	}
	
	func validate(username: String) -> Bool {
		usernameIsValid = true
		usernameWarning = ""
		if !username.lengthAtLeast6() {
			usernameWarning.append(Warning.username.tooShort)
			usernameIsValid = false
		}
		
		if !(username.oneUppserCase() || username.oneLowerCase()) {
			usernameWarning.append(Warning.username.mustContainOneLetter)
			usernameIsValid = false
		}
		
		return usernameIsValid
	}
	
	func validate(password: String) {
		passwordIsValid = true
		passwordWarning = ""
		if !password.lengthAtLeast8() {
			passwordWarning.append(Warning.password.tooShort)
			passwordIsValid = false
		}
		
		if !password.oneLowerCase() {
			passwordWarning.append(Warning.password.mustContainLowercase)
			passwordIsValid = false
		}
		
		if !password.oneUppserCase() {
			passwordWarning.append(Warning.password.mustContainUppercase)
			passwordIsValid = false
		}
		
		if !password.oneDigit() {
			passwordWarning.append(Warning.password.mustContainDigit)
			passwordIsValid = false
		}
	}
	
	func validate(email: String) {
		emailIsValid = true
		emailWarning = ""
		
		if !email.isValidEmail() {
			emailWarning.append(Warning.email.formInvalid)
			emailIsValid = true
		}
	}
	
	func passwordsMatch(pw1: String, pw2: String) {
		passwordsMatch = true
		if pw1 != pw2 {
			passwordWarning.append(Warning.password.dontMatch)
			passwordsMatch = false
		}
	}
	
	func checkUsername(username: String) {
		usernameAvailable = false
		checkerChanged?(.checking)
		
		Auth.auth().checkUsername(username: username) { (exist, message) in
			if let exist = exist {
				self.usernameAvailable = exist ? false : true
				self.checkerChanged?(exist ? .alreadyTaken : .available)
			} else {
				self.checkerChanged?(.internetError)
			}
		}
	}
}


struct Warning {
	
	struct password {
		static let tooShort = "密码至少8位\n"
		static let mustContainLowercase = "密码至少含有一位小写字母\n"
		static let mustContainUppercase = "密码至少含有一位大写字母\n"
		static let mustContainDigit = "密码至少含有一位数字\n"
		static let dontMatch = "密码不匹配\n"
	}
	
	struct username {
		static let tooShort = "用户名至少6位\n"
		static let mustContainOneLetter = "用户名至少含有一位字母\n"
	}
	
	struct email {
		static let formInvalid = "Email格式错误\n"
	}
	
}

enum Status: String {
	case available = "用户名可用"
	case alreadyTaken = "已被注册"
	case checking = "检测中..."
	case internetError = "网络异常"
}
