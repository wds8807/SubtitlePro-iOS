//
//  Extension_UIView.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/25/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UIView {
	
	func anchor(width: CGFloat, height: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		if width != 0 { widthAnchor.constraint(equalToConstant: width).isActive = true }
		if height != 0 { heightAnchor.constraint(equalToConstant: height).isActive = true }
	}
	
	func anchorNoSpacing(with view: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		self.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
	}
	
	func anchor(with view: UIView, top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
		self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left).isActive = true
		self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom).isActive = true
		self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -right).isActive = true
	}
	
	func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
		}
		if let left = left {
			self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
		}
		if let bottom = bottom {
			self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
		}
		if let right = right {
			self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
		}
		if width != 0 {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		if height != 0 {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
	
	func center(in view: UIView, x: Bool, y: Bool) {
		translatesAutoresizingMaskIntoConstraints = false
		self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = x
		self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = y
	}
	
	func center(in view: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false
		self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offsetX).isActive = true
		self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offsetY).isActive = true
	}
	
	func addSubviews(left: UIView?, middle: UIView?, right: UIView?) {
		
		self.subviews.forEach { $0.removeFromSuperview() }
		
		var views = [UIView]()
		
		if let left = left { views.append(left) }
		if let middle = middle { views.append(middle) }
		if let right = right { views.append(right) }
		
//		let dividerLineView = UIView()
//		dividerLineView.backgroundColor = .gray225
//		self.addSubview(dividerLineView)
//		dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
		
		let stackView = UIStackView(arrangedSubviews: views)
		stackView.configure(spacing: 0)
		self.addSubview(stackView)
		stackView.backgroundColor = .lightGray
		stackView.anchor(with: self, top: 0, left: 0, bottom: 0, right: 0)
	}
	
}
