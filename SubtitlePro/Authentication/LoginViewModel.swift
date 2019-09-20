//
//  LoginViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/20/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

struct LoginViewModel {
	
	var updateUI: ((Bool) -> ())?
	
	func login(username: String, password: String) {
		
		Auth.auth().login(username: username, password: password) { (success, info, message) in
			InfoView.show(message: message, success: success)
			self.updateUI?(success)
		}
	}
}
