//
//  Extension_UIKit.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 5/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension NSObject {
	func isIphoneX() -> Bool {
		if UIDevice().userInterfaceIdiom == .phone, UIScreen.main.nativeBounds.height == 2436 {
			return true
		} else {
			return false
		}
	}
	
	
	func isPad() -> Bool {
		if UIDevice().userInterfaceIdiom == .pad { return true }
		else { return false }
	}
}
