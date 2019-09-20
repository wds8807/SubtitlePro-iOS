//
//  MediaSelectorCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/17/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

class MediaSelectorCell: UICollectionViewCell {
	
	var viewModel: MediaSelectorCellViewModel? {
		didSet {
			
			viewModel?.reloadCell = { [weak self] in
				
				guard let strongSelf = self else {
					print("This medium cell does not exist")
					return
				}
				
				guard let _ = strongSelf.viewModel else {
					print("the viewModel for this cell is nil.")
					return
				}
				
				DispatchQueue.main.async {
					guard let image = self?.viewModel?.previewImage else {
						print("Image for this cell is nil, will display an empty cell.")
						return
					}
					self?.thumbImageView.image = image
					self?.durationLabel.text = self?.viewModel?.duration
				}
			}
			
			self.thumbImageView.image = viewModel?.previewImage
			self.durationLabel.text = viewModel?.duration
			
		}
	}
	
	let thumbImageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .gray128
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
		
		addSubview(thumbImageView)
		thumbImageView.anchorNoSpacing(with: self)
		addSubview(durationLabel)
		durationLabel.anchor(top: nil, left: nil, bottom: thumbImageView.bottomAnchor, right: thumbImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 8, width: 0, height: 15)
		
		isSelected ? addSelectedView() : removeSelectedView()
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
