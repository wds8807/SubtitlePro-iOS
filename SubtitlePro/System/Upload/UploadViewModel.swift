//
//  UploadViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/21/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

class UploadViewModel {
	
	var title = ""
	var description = ""
	
	init(medium: Medium) {
		self.medium = medium
	}
	
	weak var uploadController: UploadController?
	
	let medium: Medium
	
	func getTitle(_ text: String) {
		self.title = text
	}
	
	func getDescription(_ text: String) {
		self.description = text
	}
	
	func uploadVideo() {

		guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
		
		//mainController.uploadService.startUpload(medium: medium, title: title, description: description)

		//mainController.ossService.getStsToken()
	}
	
}

