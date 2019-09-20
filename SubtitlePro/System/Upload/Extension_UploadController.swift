//
//  Extension_UploadController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/23/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension UploadController {
	
	func resizeTitleTextView(){
		
		guard videoTitle.count <= 100 else {
			titleTextView.isScrollEnabled = true
			return }
		
		titleTextView.isScrollEnabled = false
		let fixedWidth = titleTextView.frame.width
		let size = CGSize(width: fixedWidth, height: .infinity)
		let newSize = titleTextView.sizeThatFits(size)
		var newFrame = titleTextView.frame
		
		newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
		let newHeight = newFrame.height
		
		let delta = newHeight - currentTitleHeight
		titleHeight?.constant += delta
		
		currentTitleHeight = newHeight
		
		modifyContainerAndContent(delta: delta)
		
	}
	
	fileprivate func modifyContainerAndContent(delta: CGFloat) {
		let buttonTop = uploadButton.frame.origin.y
		let descTVBottom = descriptionTextView.frame.origin.y + currentDescriptionHeight
		
		if buttonTop - descTVBottom <= 0 {
			
			// update scroll view content size: height
			scrollView.contentSize = CGSize(width: view.frame.width, height: currentContentHeight + delta)
			currentContentHeight += delta
			print(delta)
			// update containerView size: height
			containerHeight?.constant += delta
		}
		
		if buttonTop - descTVBottom > 19, let height = containerHeight?.constant, height > view.frame.height {
			
			// update scroll view content size: height
			scrollView.contentSize = CGSize(width: view.frame.width, height: currentContentHeight + delta)
			currentContentHeight += delta
			
			// update containerView size: height
			containerHeight?.constant += delta
		}
	}
	
	fileprivate func moveKeyboard() {
		guard let keyboardFrame = keyboardFrame else { return }
		
		let containerheightCGFloat = containerHeight?.constant ?? 0
		
		let containerBottom = containerView.frame.origin.y + containerheightCGFloat
		let descTVBottom = descriptionTextView.frame.origin.y + currentDescriptionHeight
		
		distance = keyboardFrame.height - (containerBottom - descTVBottom)

		if distance > 0 {
			var contentInset = scrollView.contentInset
			contentInset.bottom = distance
			scrollView.contentInset = contentInset
			
			let adjustment: CGFloat = isIphoneX() ? 44 : 0
			let offSet = containerBottom - view.frame.height + distance - adjustment
			if offSet > 0 {
				scrollView.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
			}
			
		}
	}
	
	func resizeDescriptionTextView() {
		
		guard videoDescription.count <= 2000 else {
			descriptionTextView.isScrollEnabled = true
			return
		}
		
		descriptionTextView.isScrollEnabled = false
		let fixedWidth = descriptionTextView.frame.width
		let size = CGSize(width: fixedWidth, height: .infinity)
		let newSize = descriptionTextView.sizeThatFits(size)
		var newFrame = descriptionTextView.frame
		
		newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
		let newHeight = newFrame.height
		
		let delta = newHeight - currentDescriptionHeight

		descriptionHeight?.constant += delta // this executes the change of textView
		
		currentDescriptionHeight = newHeight
		
		modifyContainerAndContent(delta: delta)
		
		moveKeyboard()
	}

	
}

extension UploadController {
	
	func registerForKeyboardNotification() {
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(notification: Notification) {
		
		
		//self.collectionView.isScrollEnabled = true
		guard let info = notification.userInfo else { return }
		guard let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
		
		keyboardFrame = endFrame
		
		resizeDescriptionTextView()

	}
	
	@objc func keyboardWillHide(notification: Notification) {
		
		scrollView.contentInset = .zero

	}
	
}

extension UploadController: ConfirmationDelegate {
	
	func confirmation(_ confirmation: Confirmation, action: ActionToConfirm) {
		
		guard action == .giveUpEdit else { return }
		
		
			
	}
	
	
	
}
