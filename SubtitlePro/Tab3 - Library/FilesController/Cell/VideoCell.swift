//
//  VideoCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class VideoCell: PreviewBaseCell {
	
	var viewModel: VideoCellViewModel? {
		didSet {
			imageView.image = viewModel?.previewImage
			durationLabel.text = viewModel?.duration
			dateLabel.text = viewModel?.creationDate
			dateLabel.textColor = .gray128
			subtitleLabel.text = viewModel?.subtitleText
			subtitleLabel.textColor = viewModel?.subtitleLabelTextColor
		}
	}
	
	lazy var durationLabel = label(text: "Duration：00:00")
	
	override func setupViews() {
		 super.setupViews()
		// Duration label
		addSubview(durationLabel)
		durationLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: dateLabel.leftAnchor, paddingTop: edge, paddingLeft: side+edge+inset, paddingBottom: 0, paddingRight: edge, width: 0, height: durHeight)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
