//
//  Medium.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Medium: File {
	
	var previewImage: UIImage?
	var duration: CMTime
	var avUrlAsset: AVURLAsset

	init(asset: AVURLAsset) {
		self.avUrlAsset = asset
		self.duration = asset.duration
		self.previewImage = asset.previewImage() ?? UIImage(named: "defaultImage")
		
		super.init(path: asset.url.path)
	}
	
	func data() -> Data? {
		do {
			let data = try Data(contentsOf: self.avUrlAsset.url, options: .mappedIfSafe)
			return data
		} catch {
			return nil
		}
	}
	
	var durationStr: String {
		return avUrlAsset.duration.cmTimeString
	}
	
	var subtitles: [Subtitle] {
		get {
			var array = [Subtitle]()
			let dir = (self.path as NSString).deletingLastPathComponent
			let prefix = (self.path as NSString).deletingPathExtension
			let manager = FileManager.default
			guard let enumerator = manager.enumerator(atPath: dir) else { return [] }
			for file in enumerator {
				guard let filename = file as? String else { continue }
				if (filename as NSString).pathExtension == "srt" {
					let subPath = dir + "/" + filename
					if subPath.contains(prefix) {
						let subtitle = Subtitle(path: subPath)
						array.append(subtitle)
					}
				}
			}
			return array
		}
	}
	
	func deleteSubtitles() -> Bool {
		guard self.subtitles.count > 0 else { return true }
		var success = true
		
		for file in subtitles {
			if !file.delete() { success = false }
		}
		return success
	}

}
