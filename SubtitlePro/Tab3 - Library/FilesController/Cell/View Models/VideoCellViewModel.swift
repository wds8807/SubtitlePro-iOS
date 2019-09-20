//
//  VideoCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct VideoCellViewModel {
	
	let medium: Medium
	
	var previewImage: UIImage? { return medium.avUrlAsset.previewImage() }
	var duration: String { return "Duration：" + medium.durationStr }
	var creationDate: String { return medium.creationDate().timeAgo() }
	var subtitleCount: Int { return medium.subtitles.count }
	var subtitleText: String {
		let countStr = "\(subtitleCount)"
		//let pluralStr = subtitleCount > 1 ? "s" : ""
		//let textEn = size + "  " + "\(countStr) subtitle file" + pluralStr + " available"
		let textCn = size + "  " + "\(countStr) subtitle" + " " + (subtitleCount > 1 ? "files" : "file")
		return textCn
	}
	
	var subtitleLabelTextColor: UIColor {
		return subtitleCount == 0 ? .gray128 : .gray32
	}
	var size: String { return medium.sizeStr }

	
}
