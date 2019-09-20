//
//  WaitingAnimationView.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/25/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class WaitingAnimationView: UIView {
	
	let movingBar: UIView = {
		let bar = UIView()
		bar.backgroundColor = .themeGreen
		return bar
	}()
	
	func moveRight() {
		UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.movingBar.frame.origin.x = self.bounds.width
		}) { (completed) in
			if completed { self.moveLeft() }
		}
	}
	
	func moveLeft() {
		UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.movingBar.frame = CGRect(x: -75, y: 0, width: 75, height: 5)
		}) { (completed) in
			if completed { self.moveRight() }
		}
	}
	
	func stopMoving() {
		self.layer.removeAllAnimations()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		self.clipsToBounds = true
		
	}
	
	func addBar() {
		addSubview(movingBar)
		movingBar.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: -75, paddingBottom: 0, paddingRight: 0, width: 75, height: 0)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
