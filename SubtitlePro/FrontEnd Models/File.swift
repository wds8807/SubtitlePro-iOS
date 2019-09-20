//
//  File.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

// File class that handles local file information
// It's subclassed by class Medium and Subtitle
class File {
	
	let path: String
	
	var filename: String {
		return ((path as NSString).lastPathComponent as NSString).deletingPathExtension
	}
	
	var noExtension: String {
		return (path as NSString).deletingPathExtension
	}
	
	var ext: String {
		return (path as NSString).pathExtension
	}
	
	var asset: AVAsset?
	
	init(path: String) {
		self.path = path
	}
	
	var size: UInt64? {
		get {
			do {
				let attr = try FileManager.default.attributesOfItem(atPath: self.path) as NSDictionary
				return attr.fileSize()
			} catch {
				return nil
			}
		}
	}
	
	var sizeStr: String {
		get {
			var size: UInt64
			do {
				let attr = try FileManager.default.attributesOfItem(atPath: self.path) as NSDictionary
				size = attr.fileSize()
				if size < 1024 {
					return "\(size)B"
				} else if size < 1024 * 1024 {
					let kbValue: Double = Double(size)/1024
					return String(format: "%.1f", kbValue) + "KB"
				} else if size < 1024 * 1024 * 1024 {
					let mbValue: Double = Double(size)/1024/1024
					return String(format: "%.1f", mbValue) + "MB"
				} else {
					let gbValue: Double = Double(size)/1024/1024/1024
					return String(format: "%.1f", gbValue) + "GB"
				}
			} catch {
				return "unknown"
			}
		}
	}
	
	func creationDate() -> Date {
		
		do {
			let attr = try FileManager.default.attributesOfItem(atPath: self.path)
			if let date = attr[.creationDate] as? Date {
				return date
			}
		} catch {
			print("Failed to get creation date!!!")
		}
		return Date.distantPast
	}
	
	func delete() -> Bool {
		do {
			try FileManager.default.removeItem(atPath: self.path)
			return true
		} catch {
			return false
		}
	}
}

extension PHAsset {
	
	func creationDate() -> Date {
		return self.creationDate ?? Date.distantPast
	}
}
