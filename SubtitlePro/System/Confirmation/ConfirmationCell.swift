//
//  ConfirmationCell.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/2/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

enum ConfirmationComponent {
	case description
	case confirm
	case cancel
}

struct ConfirmationDescription {
	static let deleteLine = "确认删除选定的条目\n本操作无法恢复"
	static let deleteFile = "确认删除该文件\n本操作无法恢复"
	static let deleteVideo = "确认删除选定的视频及所有相关的字幕文件\n本操作无法恢复"
	static let signOut = "真的要退出登录？"
	static let giveUpEdit = "后退之后将丢失之前所做更改"
}

struct ConfirmationConfirm {
	static let deleteLine = "确认删除"
	static let deleteFile = "确认删除文件"
	static let deleteVideo = "确认删除"
	static let signOut = "退出"
	static let giveUpEdit = "确认放弃"
}

class ConfirmationCell: UICollectionViewCell {
	
	
	let descriptionText: [ActionToConfirm: String] = [.deleteLine: ConfirmationDescription.deleteLine,
																										.deleteFile: ConfirmationDescription.deleteFile,
																										.deleteVideo: ConfirmationDescription.deleteVideo,
																										.signOut: ConfirmationDescription.signOut,
																										.giveUpEdit: ConfirmationDescription.giveUpEdit]
	
	let confirmText: [ActionToConfirm: String] = [.deleteLine: ConfirmationConfirm.deleteLine,
																								.deleteFile: ConfirmationConfirm.deleteFile,
																								.deleteVideo: ConfirmationConfirm.deleteVideo,
																								.signOut: ConfirmationConfirm.signOut,
																								.giveUpEdit: ConfirmationConfirm.giveUpEdit]
	

	override var isHighlighted: Bool {
		didSet { backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white }
	}
	
	var action: ActionToConfirm?
	
	var component: ConfirmationComponent? {
		didSet {
			guard let action = self.action, let component = self.component else { return }
			label.font = font
			label.textColor = textColor
			label.text = text(action: action, component: component)
		}
	}
	
	func text(action: ActionToConfirm, component: ConfirmationComponent) -> String {
		switch component {
		case .confirm: return confirmText[action] ?? ""
		case .description: return descriptionText[action] ?? ""
		case .cancel: return "取消"
		}
	}
	
	var font: UIFont {
		get {
			guard let component = component else { return .systemFont(ofSize: 14) }
			switch component {
			case .confirm: return .systemFont(ofSize: 17)
			case .cancel: return .boldSystemFont(ofSize: 17)
			case .description: return .systemFont(ofSize: 14)
			}
		}
	}
	
	var textColor: UIColor {
		get {
			guard let component = component else { return .gray32 }
			switch component {
			case .confirm: return .themeRed
			case .cancel: return .gray32
			case .description: return .gray128
			}
		}
	}
	
	let label: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18)
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()
	
	let dividerLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray240
		return view
	}()
	
	func setupViews() {
		
		backgroundColor = .white
		addSubview(label)
		label.anchor(with: self, top: 0, left: 15, bottom: 1, right: 15)
		addSubview(dividerLineView)
		dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
