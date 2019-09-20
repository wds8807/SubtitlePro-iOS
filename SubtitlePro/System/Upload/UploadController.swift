//
//  UploadController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/21/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class UploadController: UIViewController, UIScrollViewDelegate {
	
	var viewModel: UploadViewModel!
	var playerViewModel: VideoPlayViewModel!
	
	lazy var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.delegate = self
		scroll.alwaysBounceVertical = true
		scroll.backgroundColor = .gray64
		scroll.keyboardDismissMode = .interactive
		let padding: CGFloat = isIphoneX() ? 78 : 0
		scroll.contentSize = CGSize(width: view.frame.width, height: view.frame.height - padding)
		return scroll
	}()
	
	lazy var playerView: VideoPlayerView = {
		let width = UIScreen.main.bounds.width
		let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: width*9/16)
		let playerView = VideoPlayerView(frame: frame)
		playerView.viewModel = self.playerViewModel
		if let layer = self.playerViewModel.playerLayer {
			playerView.playerLayer = layer
			playerView.layer.insertSublayer(layer, at: 0)
		}
		playerView.delegate = self
		return playerView
	}()
	
	func textView() -> UITextView {
		let tv = UITextView()
		tv.backgroundColor = .gray40
		tv.textColor = .gray240
		tv.tintColor = .gray240
		tv.font = .boldSystemFont(ofSize: 16.dynamicSize())
		tv.layer.borderWidth = 0.5
		tv.layer.borderColor = UIColor.clear.cgColor
		tv.layer.cornerRadius = 0
		tv.keyboardAppearance = .dark
		tv.delegate = self
		tv.autoresizingMask = .flexibleHeight
		tv.isScrollEnabled = false
		var intrinsicContentSize: CGSize { return .zero }
		return tv
	}
	
	func label(text: String, textColor: UIColor) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = textColor
		label.textAlignment = .justified
		label.font = .boldSystemFont(ofSize: 15.dynamicSize())
		return label
	}
	
	let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray64
		return view
	}()
	
	lazy var uploadButton: UIButton = {
		let button = UIButton()
		button.configure(title: "确认上传", color: .white, bgColor: .themeBlue, image: nil, cornerRadius: 0)
		button.titleLabel?.font = .boldSystemFont(ofSize: 16.dynamicSize())
		button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
		button.setEnabled(false)
		return button
	}()
	
	@objc func handleUpload() {
		
		viewModel.uploadVideo()
		self.dismiss(animated: true, completion: nil)
	}
	
	lazy var titleLabel = label(text: "标题", textColor: .gray240)
	lazy var titleCountLabel = label(text: "0/100", textColor: .gray128)
	lazy var descriptionLabel = label(text: "描述", textColor: .gray240)
	lazy var descriptionCountLabel = label(text: "0/2000", textColor: .gray128)
	
	lazy var titleTextView = textView()
	lazy var descriptionTextView = textView()
	
	var titleHeight: NSLayoutConstraint?
	var descriptionHeight: NSLayoutConstraint?
	var containerHeight: NSLayoutConstraint?
	
	var currentTitleHeight: CGFloat = 0
	var currentDescriptionHeight: CGFloat = 0
	
	var keyboardFrame: CGRect?
	var distance: CGFloat = 0
	
	lazy var currentContentHeight: CGFloat = self.scrollView.contentSize.height
	
	override var prefersStatusBarHidden: Bool { return true }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		
		hideKeyBoardWhenTappedAround()
		
		registerForKeyboardNotification()
	}
	
	func setupViews() {
		
		view.addSubview(scrollView)
		scrollView.frame = view.bounds
		
		scrollView.addSubview(containerView)
		let top: CGFloat = isIphoneX() ? -44 : 0
		
		containerView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: top, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
		containerHeight = containerView.heightAnchor.constraint(equalToConstant: view.frame.height)
		containerHeight?.isActive = true
		
		containerView.addSubview(playerView)
		
		let top2: CGFloat = isIphoneX() ? 44 : 0
		playerView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: top2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width*9/16)

		containerView.addSubview(titleLabel)
		titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: view.frame.width*9/16 + top2 + 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 50, height: 30)

		containerView.addSubview(titleCountLabel)
		titleCountLabel.anchor(top: containerView.topAnchor, left: titleLabel.rightAnchor, bottom: nil, right: nil, paddingTop: view.frame.width*9/16 + top2 + 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)

		containerView.addSubview(titleTextView)
		titleTextView.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)

		titleHeight = titleTextView.heightAnchor.constraint(equalToConstant: 35)
		titleHeight?.isActive = true
		currentTitleHeight = 35

		containerView.addSubview(descriptionLabel)
		descriptionLabel.anchor(top: titleTextView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 50, height: 30)

		containerView.addSubview(descriptionCountLabel)
		descriptionCountLabel.anchor(top: titleTextView.bottomAnchor, left: descriptionLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)

		containerView.addSubview(descriptionTextView)
		descriptionTextView.anchor(top: descriptionLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)

		descriptionHeight = descriptionTextView.heightAnchor.constraint(equalToConstant: 35)
		descriptionHeight?.isActive = true
		currentDescriptionHeight = 35
		
		let bottom: CGFloat = isIphoneX() ? 34 : 0
		
		containerView.addSubview(uploadButton)
		uploadButton.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: bottom + 10, paddingRight: 15, width: 0, height: 40.dynamicHeight())

		containerView.bringSubviewToFront(playerView)
	}
	
	var videoTitle: String = ""
	var videoDescription: String = ""
}


extension UploadController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		
		let text = textView.text.trimmingCharacters(in: .whitespaces)
		let count = text.count
		
		if textView == titleTextView {
			videoTitle = text
			titleCountLabel.text = "\(count)/100"
			titleCountLabel.textColor = count <= 100 ? .gray128 : .themeRed
			viewModel.getTitle(text)
			resizeTitleTextView()
		} else if textView == descriptionTextView {
			videoDescription = text
			descriptionCountLabel.text = "\(count)/2000"
			descriptionCountLabel.textColor = count <= 2000 ? .gray128 : .themeRed
			viewModel.getDescription(text)
			resizeDescriptionTextView()
		}
		
		uploadButton.setEnabled(videoTitle.count >= 3 && videoTitle.count <= 100 && videoDescription.count <= 2000)
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		//
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		//
	}
	
}

extension UploadController: VideoPlayerDelegate {
	func playerDidClose(_ player: VideoPlayerView) {
		navigationController?.popViewController(animated: true)
	}
}

