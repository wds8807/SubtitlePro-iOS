//
//  ImageSelectorCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 3/21/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import Photos

class ImageSelectorCellViewModel {
	
	init(asset: PHAsset) {
		self.asset = asset
		loadImage()
	}
	
	var previewImage: UIImage?
	
	var asset: PHAsset
	var updateUI: (() -> ())?
	
	func loadImage() {
		let manager = PHImageManager.default()
		let targetSize = CGSize(width: 150, height: 150)
		let options = PHImageRequestOptions()
		options.deliveryMode = .opportunistic
		manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
			self.previewImage = image
			self.updateUI?()
		})
	}
}
