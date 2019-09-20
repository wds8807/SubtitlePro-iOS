//
//  HeaderView.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: NSObjectProtocol {
	func headerView(_ headerView: HeaderView, profileImageViewPressed profileImageView: CustomImageView, sender: UIGestureRecognizer)
	func headerView(_ headerView: HeaderView, profileImageViewLongPressed profileImageView: CustomImageView)
}

class HeaderView: UICollectionViewCell {
	
	weak var delegate: HeaderViewDelegate?

	var viewModel: UserProfileViewModel? {
		didSet {
			self.updateHeaderView()
		}
	}
	
	weak var userProfileController: UserProfileController?
	
	let iPad = UIDevice.current.userInterfaceIdiom == .pad
	let screenWidth = UIScreen.main.bounds.width
	
	lazy var w: CGFloat = iPad ? screenWidth * 0.3 : screenWidth * 0.36
	lazy var radius = 0.5*w
	
	lazy var profileImageView: CustomImageView = {
		let piv = CustomImageView()
		piv.image = UIImage(named: "default_user")
		piv.backgroundColor = .gray240
		piv.layer.cornerRadius = radius
		piv.clipsToBounds = true
		piv.contentMode = .scaleAspectFill
		piv.isUserInteractionEnabled = true
		piv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap(sender:))))
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleProfileImageLongTap(sender:)))
		longPress.minimumPressDuration = 1
		piv.addGestureRecognizer(longPress)
		return piv
	}()
	
	@objc func handleProfileImageLongTap(sender: UILongPressGestureRecognizer) {
		guard let viewModel = viewModel else { return }
		
		if sender.state == .began, viewModel.isCurrentUser {
			delegate?.headerView(self, profileImageViewLongPressed: self.profileImageView)
		}
	}
	
	@objc func handleProfileImageTap(sender: UITapGestureRecognizer) {
		delegate?.headerView(self, profileImageViewPressed: profileImageView, sender: sender)
	}
	
	func label(text: String? = nil) -> UILabel {
		let label = UILabel()
		label.text = text
		label.configure(fontSize: 14, bold: true, textColor: .white, lineCount: 0, alignment: .center)
		return label
	}
	
	lazy var followingLabel: UILabel = label(text: "正在关注")
	lazy var followingCountLabel: UILabel = label()
	lazy var followersLabel: UILabel = label(text: "关注者")
	lazy var followersCountLabel: UILabel = label()
	lazy var postsLabel: UILabel = label(text: "发布")
	lazy var postsCountLabel: UILabel = label()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.configure(fontSize: 16, bold: true, textColor: .gray64, lineCount: 1, alignment: .center)
		return label
	}()
	
	lazy var followButton: UIButton = {
		let button = UIButton()
		button.titleLabel?.font = .boldSystemFont(ofSize: 14)
		button.configure(title: "Follow", color: .themeGreen, bgColor: .white, image: nil, cornerRadius: 5)
		button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
		return button
	}()
	
	lazy var backButton: UIButton = {
		let button = UIButton(type: .system)
		button.configure(title: "", color: .white, bgColor: .clear, image: nil, cornerRadius: 0)
		button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
		button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
		return button
	}()
	
	@objc func handleClose() {
		self.userProfileController?.navigationController?.popViewController(animated: true)
	}
	
	@objc func handleFollow() {
		print("handling follow.")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateHeaderView() {
		guard let viewModel = viewModel else { return }
		
		if viewModel.userValid {
			profileImageView.loadImage(from: viewModel.profileImageURL)
			usernameLabel.text = viewModel.username
			// load stats of the user
		} else {
			profileImageView.image = UIImage(named: "default_user")
			usernameLabel.text = ""
			
		}
		
		setupUsernameLabelAndFollowButton()
		
	}

	fileprivate func setupUsernameLabelAndFollowButton() {
		guard let viewModel = viewModel else { return }
		let stackView = UIStackView(arrangedSubviews: [usernameLabel])
		if viewModel.userValid, !viewModel.isCurrentUser {
			stackView.addArrangedSubview(followButton)
		}
		addSubview(stackView)
		followButton.backgroundColor = .white
		stackView.configure(axis: .vertical, distribution: .fillEqually, spacing: 1)
		stackView.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: postsLabel.topAnchor, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 200, height: 0)
		stackView.center(in: self, x: true, y: false)
	}
	
	func setupSubviews() {
		
		backgroundColor = .themeLight
		addSubview(profileImageView)
		
		profileImageView.center(in: self, offsetX: 0, offsetY: isIphoneX() ? 0 : -15)
		profileImageView.anchor(width: w, height: w)
		
		let stackView1 = UIStackView(arrangedSubviews: [postsLabel, followingLabel, followersLabel])
		stackView1.configure(axis: .horizontal, distribution: .fillEqually, spacing: 5)
		
		let stackView2 = UIStackView(arrangedSubviews: [postsCountLabel, followingCountLabel, followersCountLabel])
		stackView2.configure(axis: .horizontal, distribution: .fillEqually, spacing: 5)
		let stackView = UIStackView(arrangedSubviews: [stackView1, stackView2])
		addSubview(stackView)
		stackView.configure(axis: .vertical, distribution: .fillEqually, spacing: 0)
		stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 36)
	}
	
	func addBackButton() {
		addSubview(backButton)
		backButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 36, height: 36)
	}
}

