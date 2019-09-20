//
//  FilesViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/2/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import AVFoundation

class FilesViewModel {

	private var docPath = String()
	
	init() { createDocDir() }
	
	fileprivate func createDocDir() {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		guard let docDir = paths.first else { return }
		self.docPath = docDir.appending("/files")
		do {
			try FileManager.default.createDirectory(atPath: self.docPath, withIntermediateDirectories: false, attributes: nil)
		} catch { }
	}
	
	var reloadUI: ((Int) -> ())?
	var loading: (() -> ())?
	
	private var media: [Medium] = []
	private var subtitles: [Subtitle] = []
	
	private var mediaToDelete: [Medium] = []

	func selectMediumToDelete(at index: Int) {
		guard let medium = medium(at: index) else { return }
		mediaToDelete.append(medium)
	}
	
	var numberOfMedia: Int { return media.count }
	var numberOfSubtitles: Int { return subtitles.count }
	
	func medium(at index: Int) -> Medium? {
		guard index < media.count else { return nil }
		return media[index]
	}
	
	func subtitle(at index: Int) -> Subtitle? {
		guard index < subtitles.count else { return nil }
		return subtitles[index]
	}
	
	func viewModelForMedium(at index: Int) -> VideoCellViewModel? {
		guard let medium = medium(at: index) else { return nil }
		return VideoCellViewModel(medium: medium)
	}
	
	func viewModelForSubtitle(at index: Int) -> SubtitlePreviewCellViewModel? {
		guard let subtitle = subtitle(at: index) else { return nil }
		return SubtitlePreviewCellViewModel(subtitle: subtitle, media: self.media)
	}
	
	func videoPlayViewMode(at index: Int) -> VideoPlayViewModel? {
		guard let medium = medium(at: index) else { return nil }
		return VideoPlayViewModel(medium: medium)
	}
	
	func loadFiles() {
		
		media.removeAll()
		subtitles.removeAll()
		
		let url = URL(fileURLWithPath: self.docPath)
		let manager = FileManager.default
		let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
		let options = FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants
		
		let enumerator = manager.enumerator(at: url, includingPropertiesForKeys: keys, options: options)
		


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
			
			self.media.sort { $0.creationDate() > $1.creationDate() }
			self.subtitles.sort { $0.creationDate() > $1.creationDate() }
			print("*** From file view model, there are \(self.media.count) items ***" )
			self.reloadUI?(self.media.count)
			
			
			
		} // dispatch queue async user initiated
		

		
	}
	
	func deleteSelectedMedia() {
		
		var success = true
		
		mediaToDelete.forEach { (medium) in
			
			if !medium.deleteSubtitles() { success = false }
			if !medium.delete() { success = true }
		}
		
		self.mediaToDelete.removeAll()
		
		InfoView.show(message: success ? InfoLiterals.deleteVideoSuccess : InfoLiterals.deleteVideoFail, success: success)
		
	}
}
