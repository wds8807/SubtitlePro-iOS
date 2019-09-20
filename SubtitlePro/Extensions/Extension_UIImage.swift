//
//  Extension_UIImage.swift
//  Twitter
//
//  Created by Dongshuo Wu on 6/28/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UIImage {
	
	func image(with color: UIColor) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		context.translateBy(x: 0, y: self.size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		
		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: size.height)
		guard let cgImage = self.cgImage else { return nil }
		context.clip(to: rect, mask: cgImage)
		
		color.setFill()
		context.fill(rect)
		
		guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		UIGraphicsEndImageContext()
		
		return newImage
	}
}
