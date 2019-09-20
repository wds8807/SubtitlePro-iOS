//
//  OrientationLock.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/9/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct AppUtility {
	
	static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
		if let delegate = UIApplication.shared.delegate as? AppDelegate {
			delegate.orientationLock = orientation
		}
	}
	
	static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientationMask) {
		self.lockOrientation(orientation)
		UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
	}
}
