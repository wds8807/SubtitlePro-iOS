//
//  MediaSelectorCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 3/20/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

var mediumCache = [PHAsset: Medium]()

class MediaSelectorCellViewModel {
	
	var previewImage: UIImage?
	var duration: String = ""
	
	var reloadCell: (() -> ())?
	
	// If load from photo library
	var asset: PHAsset?
	
	init(asset: PHAsset) {
		self.asset = asset
		loadAssetInfo()
	}
	
	// If load from
	var medium: Medium?
	
	init(medium: Medium) {
		self.medium = medium
		self.previewImage = medium.previewImage
		self.duration = medium.durationStr
	}
	
	func durationStr(of asset: PHAsset) -> String {
		return " " + asset.duration.durationStr + " "
	}
	
	func loadAssetInfo() {

		let manager = PHImageManager.default()
		
		guard let asset = self.asset else { return }
		
		let options = PHImageRequestOptions()
		options.deliveryMode = .opportunistic
		
		manager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: options) { (image, info) in
			if (image == nil) {
				print("This cell is going to display a empty image view.")
			}
			self.previewImage = image
			self.duration = self.durationStr(of: asset)
			self.reloadCell?()
		}
	}
	
	
}
