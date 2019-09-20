//
//  Upload.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/28/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

// Upload service creates upload objects
class Upload {
	
	var medium: Medium

	
	init(medium: Medium) {
		self.medium = medium

	}
	
	// Upload service sets these values:
	var task: URLSessionDataTask?
	var isUploading = false
	var resumeData: Data?
	
	// Upload delegate sets this value:
	var progress: Float = 0
}
