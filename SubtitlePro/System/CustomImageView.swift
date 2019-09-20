//
//  CustomImageView.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/23/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import AliyunOSSiOS

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
	
	var lastObjectKeyUsed: String?
	
//	func loadImage(from path: String) {
//
//		guard let url = URL(string: path) else { return }
//
//		lastURLUsed = path
//
//		self.image = nil
//
//		if let cachedImage = imageCache[path] {
//			self.image = cachedImage
//			return
//		}
//
//		URLSession.shared.dataTask(with: url) { (data, response, error) in
//			if let error = error {
//				print("error loading image:", error.localizedDescription)
//				return }
//
//			if url.absoluteString != self.lastURLUsed { return }
//			guard let data = data else { return }
//
//			let image = UIImage(data: data)
//
//			imageCache[url.absoluteString] = image
//
//			DispatchQueue.main.async {
//				self.image = image
//			}
//		}.resume()
//	}
	
	func loadImage(from objectKey: String) {
		print("objectKey:", objectKey)
		self.lastObjectKeyUsed = objectKey
		self.image = nil
		
		if let cachedImage = imageCache[objectKey] {
			self.image = cachedImage
			return
		}
		
		AliyunOSS.oss.getObject(from: objectKey) { (success, data, message) in
			
			if !success {
				print(message)
				return
			}
			
			guard let data = data else { return }
			
			let image = UIImage(data: data)
			
			DispatchQueue.main.async {
				self.image = image
			}
			
		}
	}
	
	
	
}
