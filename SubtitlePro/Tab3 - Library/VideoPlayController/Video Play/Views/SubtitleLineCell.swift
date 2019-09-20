//
//  SubtitleCell.swift
//  VideoPlayer
//
//  Created by Dongshuo Wu on 8/24/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

class SubtitleLineCell: UICollectionViewCell {
	
	var viewModel: SubtitleLineCellViewModel! {
		didSet {
			indexLabel.text = viewModel.lineIndex
			subtitleTextView.text = viewModel.lineText
		}
	}
	
	let indexLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.textColor = .gray32
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()
	
	let subtitleTextView: UITextView = {
		let tv = UITextView()
		tv.isEditable = false
		tv.isUserInteractionEnabled = false
		tv.textColor = .gray32
		tv.font = .systemFont(ofSize: 14)
		tv.isScrollEnabled = false
		return tv
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
		iv.image = #imageLiteral(resourceName: "checkMark")
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	
	// Sizes: based on cell height of 45
	// Label height = cell height - dividerLine height - edge * 2 = 45 - 1 - 2*2 = 40
	
	let edge: CGFloat = 4
	//let labelHeight: CGFloat = 40
	let indexWidth: CGFloat = 35
	
	// Setup views
	func setupCellViews() {
		backgroundColor = .white
		// IndexLabel 
		addSubview(indexLabel)
		indexLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: edge, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
		indexLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		addSubview(dividerLineView)
		dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: edge, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

		addSubview(subtitleTextView)
		subtitleTextView.anchor(top: topAnchor, left: indexLabel.rightAnchor, bottom: dividerLineView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: edge, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
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
		setupCellViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
