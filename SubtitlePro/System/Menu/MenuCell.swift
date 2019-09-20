//
//  MenuCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/27/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
	
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
			if self.menuItem == MenuItem.deleteFile {
				nameLabel.textColor = isHighlighted ? .themeRedDisabled : .themeRed
			} else if self.menuItem == MenuItem.login {
				nameLabel.textColor = isHighlighted ? .themeGreenDisabled : .themeGreen
			} else {
				nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
			}
			
		}
	}
	
	var menuItem: String? {
		didSet {
			guard let menuItem = menuItem else { return }
			nameLabel.text = menuItem
			if menuItem == MenuItem.deleteFile {
				nameLabel.textColor = .themeRed
			} else if menuItem == MenuItem.login {
				nameLabel.textColor = .themeGreen
				nameLabel.font = .boldSystemFont(ofSize: 18)
			} else {
				nameLabel.textColor = .gray64
			}
		}
	}
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Menu"
		label.font = UIFont.systemFont(ofSize: 18)
		label.textAlignment = .center
		return label
	}()
	
	let dividerLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray240
		return view
	}()
	
	func setupCellViews() {
		
		backgroundColor = .white
		addSubview(nameLabel)
		nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 1, paddingRight: 15, width: 0, height: 0)
		addSubview(dividerLineView)
		dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
