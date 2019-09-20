//
//  PreviewBaseCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class PreviewBaseCell: UICollectionViewCell {
	
	func label(text: String = "", textColor: UIColor = .gray32, font: UIFont = .systemFont(ofSize: 14), textAlignment: NSTextAlignment = .justified) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.textAlignment = textAlignment
		return label
	}
	
	lazy var subtitleLabel = label(text: "No subtitle file", textColor: .gray128)
	
	lazy var dateLabel = label(textColor: .gray128, textAlignment: .right)
	
	let imageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .gray240
		iv.clipsToBounds = true
		iv.contentMode = .scaleAspectFill
		iv.layer.cornerRadius = 5
		return iv
	}()
	
	let dividerLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray240
		return view
	}()
	
	let selectedView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.75, alpha: 0.5)
		return view
	}()
	
	let checkMarkIV: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(named: "checkMark")
		iv.contentMode = .scaleAspectFit
		iv.clipsToBounds = true
		return iv
	}()
	
	// Sizes, based on cell height of 70
	let edge: CGFloat = 4
	let side: CGFloat = 61
	//let durWidth: CGFloat = 50
	let dateWidth: CGFloat = 110
	let durHeight: CGFloat = 28
	let inset: CGFloat = 10
	let captionHeight: CGFloat = 28
	
	func setupViews() {
		
		backgroundColor = .white
		
		// Video preview Image view
		addSubview(imageView)
		imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: edge, paddingLeft: edge, paddingBottom: edge+1, paddingRight: 0, width: side, height: side)
		
		// Divider line view, a line with height of 1 pt
		addSubview(dividerLineView)
		dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: edge, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
		
		// Date Label
		addSubview(dateLabel)
		dateLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: edge, paddingLeft: 0, paddingBottom: 0, paddingRight: inset, width: dateWidth, height: durHeight)
		
		// Subtitle file label
		addSubview(subtitleLabel)
		subtitleLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: edge+side+inset, paddingBottom: edge+1, paddingRight: inset, width: 0, height: captionHeight)
	}
	
	func addSelectedView() {
		addSubview(selectedView)
		selectedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 1, paddingRight: 0, width: 0, height: 0)
		addSubview(checkMarkIV)
		checkMarkIV.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 6, paddingRight: 5, width: 20, height: 20)
	}
	
	func removeSelectedView() {
		selectedView.removeFromSuperview()
		checkMarkIV.removeFromSuperview()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
