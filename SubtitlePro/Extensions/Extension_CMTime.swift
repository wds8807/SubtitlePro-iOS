//
//  Extension_CMTime.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/17/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import AVFoundation

extension CMTime {
	
	func seconds() -> Double {
		return Double(CMTimeGetSeconds(self))
	}
	
	func time() -> Time {
		return Double(CMTimeGetSeconds(self)).time()
	}
}
