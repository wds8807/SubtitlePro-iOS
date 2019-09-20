//
//  Storage.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/26/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

final class Storage {
	
	private init() { }
	
	static func storage() -> Storage {
		return Storage()
	}
	
	private let profileImageUploadPath = "http://47.96.148.175/app/SubtitlePro/Upload/UploadProfileImage.php"
	private let videoUploadPath = "http://47.96.148.175/app/SubtitlePro/Upload/UploadVideo.php"
}

extension Storage {

	
	func uploadProfileImage(with data: Data, completion: ((_ success: Bool, _ info: [String: Any]?, _ message: String) -> ())? = nil) {
		
		guard let uid = User.currentUser?.id else { return }
		guard let url = URL(string: profileImageUploadPath) else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let boundary = Body.generateBoundary()
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		let filename = UUID().uuidString + ".jpg"
		
		request.httpBody = Body.body(value: ["id": String(uid), "filename": filename], filename: filename, filePathKey: "file", imageDataKey: data, boundary: boundary)
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let _ = error {
				InfoView.show(message: "无法连接服务器", success: false)
				return
			}
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
					completion?(false, nil, "返回数据格式错误")
				}
			}
		}
		task.resume()
	}

}

class Body {
	
	// Custom body of http request to upload image file
	class func body(value: [String: String], filename: String, filePathKey: String, imageDataKey: Data, boundary: String) -> Data {
		
		let lineBreak = "\r\n"
		var body = Data()
		
		for (key, value) in value {
			body.append("--\(boundary + lineBreak)")
			body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
			body.append("\(value + lineBreak)")
		}
		
		let mimetype = "image/jpg"
		
		// ** we can also pass in multiple media (images or videos) below
		// ** in a for loop
		
		body.append("--\(boundary + lineBreak)")
		body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\(lineBreak)")
		body.append("Content-Type: \(mimetype + lineBreak + lineBreak)")
		body.append(imageDataKey)
		body.append(lineBreak)
		
		// ** enclose the above in a for loop if needed
		
		body.append("--\(boundary + lineBreak)")
		
		return body
	}
	
	class func generateBoundary() -> String {
		return "Boundary-\(UUID().uuidString)"
	}

	
}


extension Data {
	
	mutating func append(_ string: String) {
		let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
		if let data = data {
			self.append(data)
		}
	}
}
