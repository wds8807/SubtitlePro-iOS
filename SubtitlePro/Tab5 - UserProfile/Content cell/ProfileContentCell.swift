//
//  ProfileContentCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class ProfileContentCell: UICollectionViewCell {
	
	var viewModel: ProfileContentCellViewModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			label.text = viewModel.labelText
			label.textColor = viewModel.textColor
		}
	}
	
	let label: UILabel = {
		let label = UILabel()
		label.configure(fontSize: 16, bold: false, textColor: .gray64, lineCount: 0, alignment: .justified)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(label)
		label.anchor(with: self, top: 10, left: 20, bottom: 10, right: 20)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
