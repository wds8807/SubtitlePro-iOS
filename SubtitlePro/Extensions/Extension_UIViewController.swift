//
//  Extension_UIViewController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/25/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UIViewController {
	func hideKeyBoardWhenTappedAround() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		tapGesture.cancelsTouchesInView = false
		
		view.addGestureRecognizer(tapGesture)
		
	}
	
	@objc func dismissKeyBoard() {
		view.endEditing(true)
	}
}

extension UIViewController {
	
	
	
//	func deregisterFromKeyboardNotification() {
//		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//	}
	
	
//	func layoutContainerView() {
//
//		let fixedWidth = containerView.commentTextView.frame.width
//		let size = CGSize(width: fixedWidth, height: .infinity)
//		let newSize = containerView.commentTextView.sizeThatFits(size)
//		var newFrame = containerView.commentTextView.frame
//		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//		let newHeight = newFrame.height
//
//		newFrame.origin.y -= (newHeight - currentTextViewHeight)
//
//		var containerFrame = self.containerView.frame
//		let newContainerHeight = newHeight+16
//
//		containerFrame.size = CGSize(width: bounds.width, height: newContainerHeight)
//		containerFrame.origin.y -= (newHeight - currentTextViewHeight)
//
//		if containerFrame.origin.y <= 0 {
//			containerView.commentTextView.isScrollEnabled = true
//		} else {
//			containerView.commentTextView.isScrollEnabled = false
//			// 2. change container height
//			containerViewHeightConstraints?.constant = newHeight + 16
//
//			// 3. modify current height
//			currentTextViewHeight = newHeight
//		}
//	}
	
}
