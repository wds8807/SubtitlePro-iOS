//
//  Extension_UIColor.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/25/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UIColor {
	static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
	
	class var gray200: UIColor {
		get { return rgb(r: 200, g: 200, b: 200, a: 1)}
	}
	
	class var twitterBlue: UIColor {
		get { return rgb(r: 45, g: 213, b: 255, a: 1)}
	}
	
	class var smoothRed: UIColor {
		get { return rgb(r: 255, g: 50, b: 75, a: 1) }
	}
	
	class var gray32: UIColor {
		get { return rgb(r: 32, g: 32, b: 32, a: 1) }
	}
	
	class var gray40: UIColor {
		get { return rgb(r: 40, g: 40, b: 40, a: 1)}
	}
	
	class var gray64: UIColor {
		get { return rgb(r: 64, g: 64, b: 64, a: 1) }
	}
	
	class var gray96: UIColor {
		get { return rgb(r: 96, g: 96, b: 96, a: 1) }
	}
	
	class var gray128: UIColor {
		get { return rgb(r: 128, g: 128, b: 128, a: 1)}
	}
	
	class var gray180: UIColor {
		get { return rgb(r: 180, g: 180, b: 180, a: 1)}
	}
	
	class var gray225: UIColor {
		get { return rgb(r: 225, g: 225, b: 225, a: 1) }
	}
	
	class var gray240: UIColor {
		get { return rgb(r: 240, g: 240, b: 240, a: 1) }
	}
	
	class var themeGreen: UIColor {
		get { return rgb(r: 60, g: 179, b: 113, a: 1) }
	}
	
	class var themeLight: UIColor {
		get { return rgb(r: 60, g: 179, b: 113, a: 0.75) }
	}
	
	class var themeGreenDisabled: UIColor {
		get { return rgb(r: 60, g: 179, b: 113, a: 0.5) }
	}
	
	class var themeBlue: UIColor {
		get { return rgb(r: 30, g: 144, b: 255, a: 1) }
	}
	
	class var themeBlueDisabled: UIColor {
		get { return rgb(r: 30, g: 144, b: 255, a: 0.5) }
	}
	
	class var themeRed: UIColor {
		get { return rgb(r: 255, g: 51, b: 51, a: 1)
		}
	}
	
	class var themeRedDisabled: UIColor {
		get { return rgb(r: 255, g: 153, b: 153, a: 1) }
	}
}
