//
//  Extension_CGRect.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/25/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UIView {
	
	var topRight: CGPoint {
		get {
			return CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
		}
	}
	
	var bottomLeft: CGPoint {
		get {
			return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height)
		}
	}
	
	var bottomRight: CGPoint {
		get {
			return CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height)
		}
	}

}
