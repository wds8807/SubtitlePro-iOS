//
//  Confirmation.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/2/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

protocol ConfirmationDelegate: NSObjectProtocol {
	func confirmation(_ confirmation: Confirmation, action: ActionToConfirm)
}

enum ActionToConfirm {
	case deleteLine, deleteFile, deleteVideo, signOut, none, giveUpEdit
}

class Confirmation: NSObject {
	
	override init() { super.init() }
	
	let cellID = "Confirmation Menu Cell"
	let cellHeight: CGFloat = 45
	
	weak var delegate: ConfirmationDelegate?
	
	var action: ActionToConfirm = .none
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .clear
		cv.delegate = self
		cv.dataSource = self
		cv.isScrollEnabled = false
		cv.register(ConfirmationCell.self, forCellWithReuseIdentifier: cellID)
		return cv
	}()
	
	lazy var blackView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 0.5)
		//view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss2)))
		return view
	}()
	
	func show(with action: ActionToConfirm) {
		
		guard let window = UIApplication.shared.keyWindow else { return }
		
		self.action = action
		
		window.addSubview(blackView)
		window.addSubview(collectionView)
		
		let height: CGFloat = cellHeight*3.3 + 3
		let y = window.frame.height - height
		
		collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
		blackView.frame = window.frame
		blackView.alpha = 0
		
		let delta: CGFloat = isIphoneX() ? 34 : 0
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.blackView.alpha = 1
			self.collectionView.frame = CGRect(x: 0, y: y-delta, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
		}) { (_) in
			self.collectionView.reloadData()
		}
	}
	
	@objc func handleDismiss2() {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.blackView.alpha = 0
			if let window = UIApplication.shared.keyWindow {
				self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			}
		})
	}
	
	func handleDismiss(for action: ActionToConfirm) {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.blackView.alpha = 0
			if let window = UIApplication.shared.keyWindow {
				self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			}
		}) { (completed: Bool) in
			self.delegate?.confirmation(self, action: self.action)
		}
	}
}

extension Confirmation: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return section == 0 ? 2 : 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ConfirmationCell
		cell.action = self.action
		
		if indexPath.section == 0 {
			
			if indexPath.item == 0 {
				cell.component = .description
			} else {
				cell.component = .confirm
			}
		} else {
			cell.component = .cancel
		}
		
		return cell
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.section == 0 && indexPath.item == 0 {
			return CGSize(width: collectionView.frame.width, height: cellHeight*1.3)
		} else {
			return CGSize(width: collectionView.frame.width, height: cellHeight)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0) : UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			handleDismiss2()
		} else if indexPath.section == 0 && indexPath.item == 1 {
			handleDismiss(for: self.action)
		}
	}
}
