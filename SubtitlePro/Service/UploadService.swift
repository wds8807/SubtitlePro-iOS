//
//  UploadService.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/28/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit


final class UploadService {
	
	init() { createDocDir() }
	
	private var docPath = String()
	
	fileprivate func createDocDir() {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		guard let docDir = paths.first else { return }
		self.docPath = docDir.appending("/files")
		do {
			try FileManager.default.createDirectory(atPath: self.docPath, withIntermediateDirectories: false, attributes: nil)
		} catch { }
	}
	
	private let videoUploadPath = "http://47.96.148.175/app/SubtitlePro/Upload/UploadVideo.php"
	private let updateInfoPath = "http://47.96.148.175/app/SubtitlePro/Upload/UpdateInfo.php"
	
	private let mimeType: [String: String] = ["mov": "video/quicktime",
																						"mp4": "video/mp4",
																						"avi": "video/x-msvideo"]
	
	
	private let boundary = "Boundary-\(UUID().uuidString)"
	
	var uploadsSession: URLSession!
	var activeUploads: [URL: Upload] = [:]
	
	func startUpload(medium: Medium, title: String, description: String) {
		
		guard let url = URL(string: videoUploadPath) else { return }
		guard let uid = User.currentUser?.id else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		//let tmpPath = medium.noExtension + ".tmp"
		let tmpPath = docPath + "/" + medium.filename + ".tmp"
		print(tmpPath)
		let urlToWrite = URL(fileURLWithPath: tmpPath)
		
		let values: [String: Any] = ["uid": uid,
																 "title": title,
																 "description": description,
																 "duration": medium.duration.seconds(),
																 "local_tmp": tmpPath]
		
		guard let fileDataToWrite = fileData(values: values, boundary: boundary, medium: medium) else {
			InfoView.show(message: "无法准备上传文件", success: false)
			return
		}
		
		do {
			try fileDataToWrite.write(to: urlToWrite)
		} catch {
			InfoView.show(message: "无法准备上传文件", success: false)
			return
		}
		
		let upload = Upload(medium: medium)
		upload.task = self.uploadsSession.uploadTask(with: request, fromFile: urlToWrite)
		upload.task?.resume()
		upload.isUploading = true
		activeUploads[urlToWrite] = upload
		
		InfoView.show(message: "上传已经开始，", success: true)
		
	}
}

extension UploadService {
	
	func fileData(values: [String: Any], boundary: String, medium: Medium) -> Data? {
		
		guard let data = medium.data() else { return nil }
		
		let lineBreak = "\r\n"
		var body = Data()
		
		for (key, value) in values {
			body.append("--\(boundary + lineBreak)")
			body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
			body.append("\(value)\(lineBreak)")
		}
		
		let filename = UUID().uuidString + "." + medium.ext

		body.append("--\(boundary + lineBreak)")
		body.append("Content-Disposition: form-data; name=\"file\";filename=\"\(filename)\"\(lineBreak)")
		
		if let type = mimeType[medium.ext] {
			body.append("Content-Type: \(type + lineBreak + lineBreak)")
		}

		body.append(data)
		body.append("\(lineBreak)--\(boundary + lineBreak)")
		
		return body
	}
	

}
