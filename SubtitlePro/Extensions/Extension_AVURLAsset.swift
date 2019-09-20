//
//  Extension_Other.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/18/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import AVFoundation
import UIKit

extension CMTime {
	
	var cmTimeString: String {
		let seconds = CMTimeGetSeconds(self)
		
		if seconds.isNaN || seconds.isInfinite {
			return "-1:0"
		}
		
		let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
		let minutesString = String(format: Int(seconds/60) < 10 ? "%01d" : "%02d", Int(seconds/60))
		return  "\(minutesString):\(secondsString)"
	}
}

extension AVURLAsset {
	
	func previewImage() -> UIImage? {
		let generator = AVAssetImageGenerator(asset: self)
		generator.appliesPreferredTrackTransform = true
		let timeStamp = CMTime(seconds: 1, preferredTimescale: 1000)
		do {
			let cgImage = try generator.copyCGImage(at: timeStamp, actualTime: nil)
			return UIImage(cgImage: cgImage)
		} catch {
			print("Failed to get preview image!!!")
			return nil
		}
	}

}


