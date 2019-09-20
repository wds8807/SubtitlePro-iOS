//
//  ImageSelectorCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 4/11/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class ImageSelectorCell: UICollectionViewCell {
	
	var viewModel: ImageSelectorCellViewModel? {
		didSet {
			viewModel?.updateUI = { [weak self]  in
				self?.thumbImageView.image = self?.viewModel?.previewImage
			}
		}
	}
		
	let thumbImageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .gray240
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	
	let durationLabel: UILabel = {
		let label = UILabel()
		label.configure(fontSize: 12, bold: true, textColor: .white, lineCount: 0, alignment: .center)
		label.layer.cornerRadius = 2
		label.layer.masksToBounds = true
		label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		label.sizeToFit()
		return label
	}()
	
	let selectedView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 1, alpha: 0.3)
		view.layer.borderColor = UIColor.themeBlue.cgColor
		view.layer.borderWidth = 4
		return view
	}()
	
	let checkMarkIV: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(named: "checkMarkBlue30")
		iv.contentMode = .scaleAspectFit
		iv.clipsToBounds = true
		return iv
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .gray240
		addSubview(thumbImageView)
		thumbImageView.anchorNoSpacing(with: self)
		addSubview(durationLabel)
		durationLabel.anchor(top: nil, left: nil, bottom: thumbImageView.bottomAnchor, right: thumbImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 8, width: 0, height: 15)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addSelectedView() {
		
		addSubview(selectedView)
		selectedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		addSubview(checkMarkIV)
		checkMarkIV.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 20, height: 20)
	}
	
	func removeSelectedView() {
		selectedView.removeFromSuperview()
		checkMarkIV.removeFromSuperview()
	}
	
}
