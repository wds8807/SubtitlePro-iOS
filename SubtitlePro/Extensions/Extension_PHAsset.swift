//
//  Extension_PHAsset.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/21/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

extension PHAsset {
	
	func getMedium(_ completion: @escaping ((Medium) -> ())) {
		
		let options = PHVideoRequestOptions()
		options.version = .current
		options.isNetworkAccessAllowed = true
		
		let manager = PHImageManager.default()
		
		manager.requestAVAsset(forVideo: self, options: options) { (avasset, audioMix, info) in
			
			if let urlAsset = avasset as? AVURLAsset {
				let medium = Medium(asset: urlAsset)
				completion(medium)
			}
		}
	}
}
