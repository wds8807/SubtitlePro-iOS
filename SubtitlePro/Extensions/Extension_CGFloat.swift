//
//  Extension_CGFloat.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/17/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension CGFloat {
	

	mutating func dynamicSize() -> CGFloat {
		return CGFloat.minimum(25, self*(UIScreen.main.bounds.width/375))
	}
	
	mutating func dyanmicWidth() -> CGFloat {
		return self*(UIScreen.main.bounds.width/375)
	}
	
	mutating func dynamicHeight() -> CGFloat {
		return self*(UIScreen.main.bounds.height/667)
	}
}

extension Int {
	
	func dynamicSize() -> CGFloat {
		return CGFloat.minimum(16, CGFloat(self)*(UIScreen.main.bounds.width/31.25/12))
	}
	
	func dyanmicWidth() -> CGFloat {
		return CGFloat.minimum(CGFloat(self)*(UIScreen.main.bounds.width/375), CGFloat(self)*1.25)
	}
	
	func dynamicHeight() -> CGFloat {
		return CGFloat.minimum(CGFloat(self)*(UIScreen.main.bounds.height/667), CGFloat(self)*1.25)
	}
}
