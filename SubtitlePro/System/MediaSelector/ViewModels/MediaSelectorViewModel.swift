//
//  MediaSelectorViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit
import Photos

enum FetchLocation { case appLibrary, photoLibrary }
enum Purpose { case toUpload, toImport }

class MediaSelectorViewModel {
	
	init() { createDocDir() }
	
	fileprivate func createDocDir() {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		guard let docDir = paths.first else { return }
		self.docPath = docDir.appending("/files")
		do {
			try FileManager.default.createDirectory(atPath: self.docPath, withIntermediateDirectories: false, attributes: nil)
		} catch { }
	}
	
	private var docPath = String()
	
	var fetchLocation: FetchLocation?
	var purpose: Purpose?
	
	var backgroundColor: UIColor {
		return purpose == .toUpload ? UIColor.gray40 : UIColor.white
	}
	
	private var assets: [PHAsset] = []
	
	var reloadUI: (() -> ())?
	
	var numberOfItems: Int = 0 {
		didSet {
			reloadUI?() }
	}
	
	var exportFinished: ((Bool) -> ())?
	
	private var media: [Medium] = []
	
	var mediumSelected: ((Bool) -> ())?
	
	var selectedMedium: Medium? {
		didSet {
			mediumSelected?(selectedMedium != nil)
		}
	}
	
	func selectMedium(at index: Int) {
		
		self.selectedMedium = nil
		
		if let medium = medium(at: index) {
			self.selectedMedium = medium
		} else if let asset = asset(at: index) {
			asset.getMedium { (medium) in
				self.selectedMedium = medium
			}
		}
	}
	
	func clearSelection() { self.selectedMedium = nil }
	
	func medium(at index: Int) -> Medium? {
		guard index < media.count else { return nil }
		return media[index]
	}

	
	func asset(at index: Int) -> PHAsset? {
		guard index < assets.count else { return nil }
		return assets[index]
	}
	
	func cellViewModel(at index: Int) -> MediaSelectorCellViewModel? {
		
		
		guard let location = self.fetchLocation else { return nil }
		
		switch location {
			
		case .photoLibrary:
			
			guard let asset = asset(at: index) else { return nil }
			let viewModel = MediaSelectorCellViewModel(asset: asset)
			return viewModel
			
		case .appLibrary:
			
			guard let medium = medium(at: index) else { return nil }
			let viewModel = MediaSelectorCellViewModel(medium: medium)
			return viewModel
			
		}
	}
	
//	func titleDescriptionViewModelForSelectedMedium() -> TitleDescriptionViewModel? {
//		guard let medium = selectedMedium else { return nil }
//		let viewModel = TitleDescriptionViewModel(medium: medium)
//		viewModel.fetchLocation = self.fetchLocation
//		return viewModel
//	}
	
	
	
	fileprivate func assetsFetchOptions() -> PHFetchOptions {
		let fetchOptions = PHFetchOptions()
		fetchOptions.fetchLimit = 0
		let discriptor = NSSortDescriptor(key: "creationDate", ascending: false)
		fetchOptions.sortDescriptors = [discriptor]
		return fetchOptions
	}
	
	func fetchAVURLVideos() {
		
		PHPhotoLibrary.requestAuthorization { (status) in
			switch status {
			case .authorized:
				
				if self.fetchLocation == .photoLibrary {
					self.fetchFromPhotoLibrary()
				}
					
				else if self.fetchLocation == .appLibrary {
					self.fetchFromAppLibrary()
				}
				
			case .denied, .restricted:
				print("User didn't allow to fetch photo.")
			case .notDetermined:
				print("Not determined yet.")
			@unknown default:
				break
			}
		}
	}
	
	fileprivate func fetchFromPhotoLibrary() {
		
		let outerGroup = DispatchGroup()
		outerGroup.enter()
		
		DispatchQueue.global(qos: .userInitiated).async {
			let allVideos = PHAsset.fetchAssets(with: .video, options: self.assetsFetchOptions())
			
			self.numberOfItems = allVideos.count
			
			allVideos.enumerateObjects { (asset, count, stop) in
				self.assets.append(asset)
			}
			outerGroup.leave()
		}
		outerGroup.wait()

		self.assets.sort { $0.creationDate() > $1.creationDate() }

		self.reloadUI?()
	}
	
	func fetchFromAppLibrary() {
		
		let url = URL(fileURLWithPath: self.docPath)
		let manager = FileManager.default
		let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
		let options = FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants
		
		let enumerator = manager.enumerator(at: url, includingPropertiesForKeys: keys, options: options)
	
		let group = DispatchGroup()
		group.enter()
		
		DispatchQueue.global(qos: .userInitiated).async {
			
			while let url = enumerator?.nextObject() as? URL {
				
				let ext = url.pathExtension
				
				if ext.caseInsensitiveCompare("mov") == .orderedSame ||
					ext.caseInsensitiveCompare("mp4") == .orderedSame ||
					ext.caseInsensitiveCompare("avi") == .orderedSame {
					
					let asset = AVURLAsset(url: url)
					let medium = Medium(asset: asset)
					self.media.append(medium)
				}
			}
			
			self.numberOfItems = self.media.count
			group.leave()
		}
		group.wait()
		
		self.media.sort { $0.creationDate() > $1.creationDate() }
		self.reloadUI?()
	}
	
	func exportAsset(at index: Int) {
		let manager = PHImageManager.default()
		
		guard let asset = asset(at: index) else { return }
		
		manager.requestExportSession(forVideo: asset, options: options(), exportPreset: AVAssetExportPresetHighestQuality) { (exportSession, info) in
			
			guard let exportSession = exportSession else { return }
			guard let urlAsset = exportSession.asset as? AVURLAsset else { return }
			let srcURL = urlAsset.url
			
			let components = urlAsset.url.path.components(separatedBy: "/")
			guard let filename = components.last else { return }

			let dstURL = URL(fileURLWithPath: self.docPath.appending("/" + filename))
			
			do {
				try FileManager.default.copyItem(at: srcURL, to: dstURL)
				self.exportFinished?(true)
			} catch {
				self.exportFinished?(false)
			}
		}
	}
	
	fileprivate func options() -> PHVideoRequestOptions {
		let options = PHVideoRequestOptions()
		options.version = .current
		options.isNetworkAccessAllowed = true
		return options
	}
	
}
