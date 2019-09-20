//
//  SubtitleFileCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class SubtitleFileCell: PreviewBaseCell {
	
	var viewModel: SubtitlePreviewCellViewModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			imageView.image = viewModel.image
			subtitleLabel.text = viewModel.linkedToVideoText
			subtitleLabel.textColor = viewModel.linkedToVideoColor
			sizeLabel.text = viewModel.size
			dateLabel.text = viewModel.creationDate
		}
	}
	
	
	lazy var sizeLabel = label(textColor: .gray128)
	
	override func setupViews() {
		super.setupViews()
		// Duration label
		addSubview(sizeLabel)
		sizeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: dateLabel.leftAnchor, paddingTop: edge, paddingLeft: side+edge+inset, paddingBottom: 0, paddingRight: edge, width: 0, height: durHeight)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
