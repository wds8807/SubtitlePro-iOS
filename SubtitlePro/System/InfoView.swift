//
//  InfoView.swift
//  Twitter
//
//  Created by Dongshuo Wu on 6/27/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class InfoView: UIView {
	
	static var isShowing = false
	
	private var isShowing = false
	
	static func show(message: String, success: Bool) {
		
		if isShowing { return }
		
		DispatchQueue.main.async {
			
			guard let window = UIApplication.shared.keyWindow else { return }
			let height = window.frame.height / 20
			
			let width = window.frame.width
			let bottom = window.frame.height
			
			let infoView = UIView(frame: CGRect(x: 0, y: bottom, width: width, height: height))
			infoView.backgroundColor = success ? .themeGreen : .smoothRed
			
			let infoLabel = UILabel()
			infoLabel.sizeToFit()
			infoLabel.text = "  " + message
			infoLabel.backgroundColor = success ? .themeGreen : .smoothRed
			print(UIScreen.main.bounds.width)
			infoLabel.configure(fontSize: CGFloat.dynamicSize(), bold: false, textColor: .white, lineCount: 0, alignment: .justified)
			infoView.addSubview(infoLabel)
			infoLabel.anchorNoSpacing(with: infoView)
			
			window.addSubview(infoView)
			
			let delta: CGFloat = UIApplication.shared.isIphoneX() ? 34 : 0
			
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
				
				infoView.frame.origin.y = bottom - height - delta
				
			}) { (isFinished) in
				
				UIView.animate(withDuration: 0.2, delay: 3, options: .curveLinear, animations: {
					infoView.frame.origin.y = bottom
				}, completion: { (isFinished) in
					infoView.removeFromSuperview()
					self.isShowing = false
				})
				
			}
			
		}
		
	}
}
