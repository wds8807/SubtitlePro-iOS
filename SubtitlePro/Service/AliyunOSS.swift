//
//  AliyunOSS.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 9/28/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import AliyunOSSiOS

public class AliyunOSS: NSObject, URLSessionDelegate {
	
	private var token: OSSFederationToken?
	
	private var accessKey: String?
	private var accessKeySecret: String?
	
	private lazy var callBackURLs: [String: String] =
		[Dir.previewImages: uploadPreviewImageCallBack,
		 Dir.profileImages: uploadProfileImageCallBack,
		 Dir.videos: uploadVideoCallBack,
		 Dir.subtitles: uploadSubtitleCallBack]
	
	private let callBack = "http://47.96.148.175/app/SubtitlePro/Upload/CallBack.php"
	
	private let uploadProfileImageCallBack = "http://47.96.148.175/app/SubtitlePro/Upload/UploadProfileImageCallBack.php"
	private let uploadPreviewImageCallBack = "http://47.96.148.175/app/SubtitlePro/Upload/UploadPreviewImageCallBack.php"
	private let uploadVideoCallBack = "http://47.96.148.175/app/SubtitlePro/Upload/UploadVideoCallBack.php"
	private let uploadSubtitleCallBack = "http://47.96.148.175/app/SubtitlePro/Upload/UploadSubtitleCallBack.php"
	
	var client: OSSClient?
	
	private func initOSSClient() {
		
		let provider = OSSAuthCredentialProvider(authServerUrl: OSS_STSTOKEN_URL)
		
		let configuration = OSSClientConfiguration()
		configuration.maxRetryCount = 3
		configuration.timeoutIntervalForRequest = 30
		configuration.timeoutIntervalForResource = 24 * 60 * 60
		
		self.client = OSSClient(endpoint: OSS_ENDPOINT, credentialProvider: provider, clientConfiguration: configuration)
	}
	
	private override init() {
		super.init()
		self.initOSSClient()
	}
	
	static let oss = AliyunOSS()
	
	struct Dir {
		static let previewImages = "preview_images/"
		static let profileImages = "profile_images/"
		static let subtitles = "subtitles/"
		static let videos = "videos/"
	}

	func getStsToken(_ completion: @escaping (Bool) -> ()) {

		let tcs = OSSTaskCompletionSource<AnyObject>()
		let federationProvider = OSSFederationCredentialProvider { () -> OSSFederationToken? in

			guard let url = URL(string: OSS_STSTOKEN_URL) else { return nil }
			let config = URLSessionConfiguration.default
			let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)

			let task = session.dataTask(with: url, completionHandler: { (data, response, error) in

				tcs.setResult(data as AnyObject)
			})
			task.resume()
			tcs.task.waitUntilFinished()

			do {
				let json = try JSONSerialization.jsonObject(with: tcs.task.result as! Data, options: .allowFragments) as? [String: Any]
				guard let parsedJson = json else { return nil }
				
				let accessKeyId = parsedJson["AccessKeyId"] as? String ?? ""
				let accessKeySecret = parsedJson["AccessKeySecret"] as? String ?? ""

				let token = OSSFederationToken()
				token.tAccessKey = accessKeyId
				token.tSecretKey = accessKeySecret
				self.token = token
				completion(true)
				return token
			} catch {
				completion(false)
				return nil
			}
		}

		do {
			try federationProvider.getToken()
		} catch {
			print("Get Error")
		}
	}
	
	
	func upload(videoURL: URL, destinationDir: String, completion: @escaping (_ success: Bool, _ message: String) -> ()) {
		
	
	}
	
	
//
	func putObject(image: UIImage, quality: CGFloat, destinationDir: String, completion: @escaping(_ success: Bool, _ message: String, _ objectKey: String) -> ()) {
		
		let request = OSSPutObjectRequest()
		guard let data = image.jpegData(compressionQuality: quality) else {
			InfoView.show(message: "图片已经损坏", success: false)
			return
		}

		request.uploadingData = data
		request.bucketName = OSS_BUCKET_PRIVATE
		let filename = NSUUID().uuidString
		let objectKey = destinationDir + filename + ".jpeg"
		request.objectKey = objectKey
		
		//guard let uid = User.currentUser?.id, let callBackURL = callBackURLs[dir] else { return }
		guard let uid = User.currentUser?.id else { return }
		
		let callBackBody = "uid=\(uid)&object=\(objectKey)"
		let callbackParam: [String: Any] = ["callbackUrl": callBack,
																				"callbackBody": callBackBody]

		request.callbackParam = callbackParam
		
		if self.client == nil { self.initOSSClient() }
		
		let task = self.client?.putObject(request)

		task?.continue({ (t) -> Any? in
			
			if let error = t.error {
				completion(false, error.localizedDescription, "")
				print(error)
			} else if let result = t.result {
				completion(true, result.description ?? "", objectKey)
			}
			
			return nil
		}).waitUntilFinished()
	}
	
	func getObject(from objectKey: String, _ completion: @escaping (Bool, Data?, String) -> ()) {
		
		let request = OSSGetObjectRequest()
		request.bucketName = OSS_BUCKET_PRIVATE
		request.objectKey = objectKey
		print(objectKey)
	
		
		let task = self.client?.getObject(request)
		
		task?.continue({ (t) -> Any? in
			
			if let error = t.error {
				print(error)
				completion(false, nil, "任务发生错误")
			} else if let result = t.result {
				if let data = result.downloadedData {
					completion(true, data, "加载成功")
				} else {
					completion(false, nil, "数据无效")
				}
			}
			
			return nil
		})
	}
	

	func triggerCallback() {

		let provider = OSSAuthCredentialProvider(authServerUrl: OSS_STSTOKEN_URL)
		let client = OSSClient(endpoint: OSS_ENDPOINT, credentialProvider: provider)
		
		let request = OSSCallBackRequest()
		request.bucketName = OSS_BUCKET_PRIVATE
		request.objectName = "videos/NYC Subway HD 60fps_ Snowy Day Along The BMT Brighton Line (2_10_17).mp4"
		request.callbackParam = ["callbackUrl": self.callBack, "callbackBody": "test"]
		
		let task = client.triggerCallBack(request)
		task.continue({ (t) -> Any? in
			if let result = t.result {
				print("Result:", result)
			} else if let error = t.error {
				print("Error:", error)
			}
			return nil
		}).waitUntilFinished()
	}


}
