//
//  extensions.swift
//  LocalView
//
//  Created by Dongshuo Wu on 6/9/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit
import AVFoundation

extension UIButton {
	
	func setEnabled(_ enabled: Bool) {
		self.isEnabled = enabled
		self.backgroundColor = self.backgroundColor?.withAlphaComponent(enabled ? 1 : 0.3)
		self.titleLabel?.textColor = self.titleLabel?.textColor.withAlphaComponent(enabled ? 1 : 0.3)
	}
	
	func configure(title: String, color: UIColor, bgColor: UIColor, image: UIImage?, cornerRadius: CGFloat) {
		if let image = image {
			self.setImage(image, for: .normal)
			self.imageView?.image = image.withRenderingMode(.alwaysOriginal)
		}
		self.imageView?.tintColor = color
		self.tintColor = color
		self.setTitleColor(color, for: .normal)
		self.backgroundColor = bgColor
		self.layer.cornerRadius = cornerRadius
		self.setTitle(title, for: .normal)
	}

	func changeState(isEnabled: Bool, bgColor: UIColor) {
		self.isEnabled = isEnabled
		self.backgroundColor = bgColor
	}
}

extension CGFloat {
	static func dynamicSize() -> CGFloat {
		let size = UIScreen.main.bounds.width / 24
		return size < 18 ? size : 18
	}
}

extension UILabel {
	func configure() {
		self.numberOfLines = 0
		self.textColor = .gray128
		self.font = UIFont.boldSystemFont(ofSize: 15)
	}
	
	func configure(fontSize: CGFloat, bold: Bool, textColor: UIColor, lineCount: Int, alignment: NSTextAlignment) {
		self.font = bold == true ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
		self.textColor = textColor
		self.numberOfLines = lineCount
		self.textAlignment = alignment
	}
	
	func forSubtitleDisplay() {
		self.backgroundColor = .clear
		self.textAlignment = .center
		self.numberOfLines = 0
		self.font = UIFont.boldSystemFont(ofSize: UI_USER_INTERFACE_IDIOM() == .pad ? 30 : 15)
		self.textColor = UIColor.white
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		self.layer.shadowOpacity = 0.9
		self.layer.shadowRadius = 1.0
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = UIScreen.main.scale
		self.lineBreakMode = .byWordWrapping
		self.sizeToFit()
	}
}

extension UITextView {
	
	func configure(fontSize: CGFloat = 14, bold: Bool = false, textColor: UIColor = .gray64, borderColor: UIColor = .themeGreenDisabled, borderWidth: CGFloat = 1.5, cornerRadius: CGFloat = 5) {
		self.textColor = textColor
		self.font = bold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
		self.layer.borderWidth = borderWidth
		self.layer.cornerRadius = cornerRadius
		self.layer.borderColor = borderColor.cgColor
	}
}

extension UITextField {
	
	func configure() {
		self.borderStyle = .none
		self.layer.borderColor = UIColor.themeGreenDisabled.cgColor
		self.textColor = .gray128
		self.layer.borderWidth = 1.5
		self.layer.cornerRadius = 0
		self.textAlignment = .center
		self.font = .boldSystemFont(ofSize: 16)
		self.keyboardType = .numberPad
	}
	
	func configure(borderStyle: UITextField.BorderStyle, borderColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
		self.borderStyle = borderStyle
		self.layer.borderColor = borderColor.cgColor
		self.backgroundColor = backgroundColor
		self.layer.borderWidth = 1.5
		self.layer.cornerRadius = cornerRadius
	}
	
	func changeState(for isInputValid: Bool) {
		self.layer.borderWidth = 3
		if isInputValid {
			self.layer.borderColor = UIColor.themeRedDisabled.cgColor
			self.backgroundColor = .themeRedDisabled
		} else {
			self.layer.borderColor = UIColor.themeRedDisabled.cgColor
			self.backgroundColor = .themeRedDisabled
		}
	}
}

extension UIStackView {
	func configure(spacing: CGFloat) {
		self.axis = .horizontal
		self.distribution = .fillEqually
		self.spacing = spacing
		self.backgroundColor = .white
	}
	
	func configure(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) {
		self.axis = axis
		self.distribution = distribution
		self.spacing = spacing
	}
	
	func configureSubViews() {
		self.subviews.forEach { (view) in
			if let label = view as? UILabel {
				label.configure()
				label.textAlignment = .center
			} else if let textView = view as? UITextView {
				textView.configure()
			} else if let textField = view as? UITextField {
				textField.configure()
			}
		}
	}
}





