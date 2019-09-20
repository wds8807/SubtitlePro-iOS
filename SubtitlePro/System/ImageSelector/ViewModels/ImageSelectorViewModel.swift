//
//  ImageSelectorViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 3/21/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import Photos

class ImageSelectorViewModel {
	
	private var selectedImage: UIImage? {
		didSet { didSelectImage?(selectedImage) }
	}
	var didSelectImage: ((UIImage?) -> ())?
	
	private var selectedAsset: PHAsset? {
		didSet { selectedAsset?.getOrigionalImage({ (image) in
			self.selectedImage = image
		})}
	}
	
	var reloadUI: (() -> ())?
	
	var numberOfItems: Int { return self.assets.count }
	
	var assets: [PHAsset] = []
	
	func asset(at index: Int) -> PHAsset? {
		guard index < assets.count else { return nil }
		return assets[index]
	}
	
	func viewModel(for index: Int) -> ImageSelectorCellViewModel? {
		guard let asset = asset(at: index) else { return nil }
		return ImageSelectorCellViewModel(asset: asset)
	}
	
	func selectAsset(at index: Int) {
		guard index < assets.count else { return }
		selectedAsset = assets[index]
	}
	
	fileprivate func fetchOptions() -> PHFetchOptions {
		let fetchOptions = PHFetchOptions()
		
		fetchOptions.fetchLimit = 0
		let descriptor = NSSortDescriptor(key: "creationDate", ascending: false)
		fetchOptions.sortDescriptors = [descriptor]
		return fetchOptions
	}
	
	func getSelectedImage() -> UIImage? { return self.selectedImage }
	
	func tryFetchPhotos() {
		
		PHPhotoLibrary.requestAuthorization { (status) in
			switch status {
			case .authorized: self.fetchPhotos()
			case .denied, .restricted:
				print("User didn't allow to fetch photo.")
			case .notDetermined:
				print("Not determined yet.")
			}
		}
	}
	
	func fetchPhotos() {
		
		let group = DispatchGroup()
		group.enter()
		
		DispatchQueue.global(qos: .userInitiated).async {
			let allPhotos = PHAsset.fetchAssets(with: .image, options: self.fetchOptions())
			allPhotos.enumerateObjects({ (asset, count, stop) in
				self.assets.append(asset)
			})
			group.leave()
		}
		group.wait()
		// reload UI here
		self.assets.sort { ($0.creationDate ?? Date.distantPast) > ($1.creationDate ?? Date.distantPast) }
		self.reloadUI?()
	}
	
	
}

extension PHAsset {
	
	func getOrigionalImage(_ completion: @escaping ((UIImage?) -> ())) {
		let manager = PHImageManager.default()
		let options = PHImageRequestOptions()
		options.version = .original
		//options.isSynchronous = true
		manager.requestImageData(for: self, options: options) { (data, string, orientation, info) in
			if let data = data {
				completion(UIImage(data: data))
			}
		}
	}
}
