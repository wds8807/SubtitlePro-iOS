//
//  Menu.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/27/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

protocol MenuDelegate: NSObjectProtocol {
	func menu(_ menu: Menu, didSelect item: String)
	func menu(_ menu: Menu, didTapBlackView blackView: UIView)
}

class Menu: NSObject {
	
	override init() { super.init() }
	
	let cellID = "menu cell"
	let cellHeight: CGFloat = 45
	
	weak var delegate: MenuDelegate?
	
	var items: [String] = [] {
		didSet {
			self.collectionView.reloadData()
		}
	}
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .clear
		cv.isScrollEnabled = false
		cv.dataSource = self
		cv.delegate = self
		cv.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
		return cv
	}()
	
	lazy var blackView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = true
		view.backgroundColor = UIColor(white: 0, alpha: 0.5)
		let tap = UITapGestureRecognizer(target: self, action: #selector(blackViewTapped))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		return view
	}()
	
	@objc func blackViewTapped() {
		print("black view tapped.")
		delegate?.menu(self, didTapBlackView: self.blackView)
	}
	
	// -- Dismiss #1: On tapping on one of the menu items
	func handleDismiss(for item: String) {
		
		UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.blackView.alpha = 0
			guard let window = UIApplication.shared.keyWindow else { return }
			self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.collectionView.frame.height)
		}) { (_) in
			self.delegate?.menu(self, didSelect: item)
		}
	}
	
	// -- Dismiss #2: On tapping on the black view
	@objc func handleDismiss2() {
		UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.blackView.alpha = 0
			if let window = UIApplication.shared.keyWindow {
				self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			}
		})
	}
	
	func show(items: [String]) {
		
		guard let window = UIApplication.shared.keyWindow else { return }
		
		window.addSubview(blackView)
		window.addSubview(collectionView)
		let height = CGFloat(items.count) * cellHeight + 3
		let y = window.frame.height - height
		
		collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
		blackView.frame = window.frame
		blackView.alpha = 0
		window.bringSubviewToFront(collectionView)
		
		self.items = items
		
		if isIphoneX() {
			UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.blackView.alpha = 1
				self.collectionView.frame = CGRect(x: 0, y: y-34, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			})
		} else {
			UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.blackView.alpha = 1
				self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			})
		}
	}
}

extension Menu: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return section == 0 ? items.count - 1 : 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
		cell.menuItem = indexPath.section == 0 ? items[indexPath.item] : items.last
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0) : UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let item = self.items[indexPath.item]
		if indexPath.section == 1 {
			handleDismiss2()
		} else {
			handleDismiss(for: item)
		}
	}
	
}
