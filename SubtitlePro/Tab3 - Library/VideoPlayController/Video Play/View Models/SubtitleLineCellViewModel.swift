//
//  SubtitleLineCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 3/26/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct SubtitleLineCellViewModel {
	
	let line: Line
	
	var lineIndex: String { return String(line.index) }
	var lineText: String { return line.text }
}
