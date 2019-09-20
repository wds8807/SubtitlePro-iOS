//
//  SubtitleCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/2/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct SubtitlePreviewCellViewModel {
	
	let subtitle: Subtitle
	let media: [Medium]
	
	var image: UIImage? { return UIImage(named: "file") }
	var linkedToVideo: Bool { return subtitle.isAssociated(with: media) }
	var linkedToVideoText: String { return linkedToVideo ? "Linked to video" : "Not linked to video" }
	var linkedToVideoColor: UIColor { return linkedToVideo ? .gray64 : .gray128 }
	var size: String { return subtitle.sizeStr }
	var creationDate: String { return subtitle.creationDate().timeAgoChn() }
}
