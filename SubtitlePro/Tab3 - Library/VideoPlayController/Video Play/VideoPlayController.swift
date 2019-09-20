//
//  VideoPlayController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/6/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import AVFoundation

public class VideoPlayController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	weak var filesController: FilesController?
	
	enum Mode: String {
		case none
		case addLine
		case editLine
		case deleteLines
	}
	
	var mode: Mode = .none {
		didSet {
			configureButtonContainerView(for: mode)
			switch mode {
			case .none:
				unselectCells()
				subtitleCollectionView.allowsSelection = false
				break
			case .addLine:
				subtitleCollectionView.allowsSelection = false
				break
			case .editLine:
				subtitleCollectionView.allowsSelection = true
				subtitleCollectionView.allowsMultipleSelection = false
				break
			case .deleteLines:
				subtitleCollectionView.allowsSelection = true
				subtitleCollectionView.allowsMultipleSelection = true
				break
			}
		}
	}
	
	fileprivate func configureButtonContainerView(for mode: Mode) {
		switch mode {
		case .addLine, .none:
			// menu button, switch button
			buttonContainerView.addSubviews(left: fileInfoLabel, middle: menuButton, right: switchButton)
			break
		case .editLine:
			// please edit label, done editing button
			buttonContainerView.addSubviews(left: fileInfoLabel, middle: pleaseEditLabel, right: cancelEditButton)
			break
		case .deleteLines:
			// cancel delete button, delete selected line button
			buttonContainerView.addSubviews(left: fileInfoLabel, middle: cancelDeleteButton, right: deleteSelectedButton)
			break
		}
	}
	
	lazy var lineEditor: LineEditor = {
		let delta: CGFloat = isIphoneX() ? 44 + 34 : 0
		let height = view.frame.height - view.frame.width*9/16 - delta
		let width = view.frame.width
		let y = view.frame.height
		let frame = CGRect(x: 0, y: y, width: width, height: height)
		let le = LineEditor(frame: frame)
		le.viewModel = LineEditorViewModel()
		le.backgroundColor = .white
		le.delegate = self
		return le
	}()
	
	let pleaseEditLabel: UILabel = {
		let label = UILabel()
		label.text = "选择要修改的条目"
		label.font = .boldSystemFont(ofSize: 14.dynamicSize())
		label.textColor = .gray128
		label.textAlignment = .center
		return label
	}()
	
	lazy var deleteSelectedButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14.dynamicSize())
		button.configure(title: "删除", color: .white, bgColor: .themeRed, image: nil, cornerRadius: 0)
		button.addTarget(self, action: #selector(handleDeleteSelectedTapped), for: .touchUpInside)
		button.setEnabled(viewModel.linesToRemoveCount > 0 ? true : false)
		return button
	}()
	
	@objc func handleDeleteSelectedTapped() {
		confirmation.show(with: .deleteLine)
	}
	
	let cancelEditButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14.dynamicSize())
		button.configure(title: "取消编辑", color: .white, bgColor: .themeBlue, image: nil, cornerRadius: 0)
		button.addTarget(self, action: #selector(handleCancelEdit), for: .touchUpInside)
		return button
	}()
	
	@objc func handleCancelEdit() {
		self.mode = .none
	}
	
	let cancelDeleteButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14.dynamicSize())
		button.configure(title: "取消操作", color: .white, bgColor: .themeBlue, image: nil, cornerRadius: 0)
		button.addTarget(self, action: #selector(handleCancelDeleteTapped), for: .touchUpInside)
		return button
	}()
	
	@objc func handleCancelDeleteTapped() {
		viewModel.cancelDeletionSelect()
		self.mode = .none
	}
	
	lazy var menu: Menu = {
		let menu = Menu()
		menu.delegate = self
		return menu
	}()
	
	lazy var confirmation: Confirmation = {
		let c = Confirmation()
		c.delegate = self
		return c
	}()
	
	lazy var switchButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14.dynamicSize())
		button.configure(title: "下一个文件", color: .white, bgColor: .themeGreen, image: nil, cornerRadius: 0)
		button.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
		button.setEnabled(viewModel?.numberOfSubtitles ?? 0 > 1 ? true : false)
		return button
	}()
	
	@objc func handleSwitch() {
		viewModel.switchSubtitle()
	}
	
	let menuButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14.dynamicSize())
		button.configure(title: "菜单", color: .white, bgColor: .themeBlue, image: nil, cornerRadius: 0)
		button.addTarget(self, action: #selector(handleMenuTapped), for: .touchUpInside)
		return button
	}()
	
	@objc func handleMenuTapped() {
		menu.show(items: [MenuItem.createFile, MenuItem.addLine, MenuItem.editLine, MenuItem.deleteLine, MenuItem.deleteFile, MenuItem.cancel])
	}
	
	var viewModel: VideoPlayViewModel!
	
	let cellID = "line cell"
	
	lazy var playerView: VideoPlayerView = {
		let width = UIScreen.main.bounds.width
		let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: width*9/16)
		let playerView = VideoPlayerView(frame: frame)
		playerView.viewModel = self.viewModel
		if let layer = self.viewModel?.playerLayer {
			playerView.playerLayer = layer
			playerView.layer.insertSublayer(layer, at: 0)
		}
		playerView.videoPlayController = self
		playerView.delegate = filesController
		return playerView
	}()
	
	let fileInfoLabel = UILabel()
	
	let subtitleLabel: UILabel = {
		let label = UILabel()
		label.forSubtitleDisplay()
		return label
	}()
	
	lazy var subtitleCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .gray225
		cv.alwaysBounceVertical = true
		cv.register(SubtitleLineCell.self, forCellWithReuseIdentifier: cellID)
		cv.delegate = self
		cv.dataSource = self
		return cv
	}()
	
	let iPhoneXStatusBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		return view
	}()
	
	lazy var iPhoneXBottomView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		return view
	}()
	
	func addStatusBarView() {
		view.addSubview(iPhoneXStatusBarView)
		iPhoneXStatusBarView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
		
	}
	
	func addBottomView() {
		view.addSubview(iPhoneXBottomView)
		iPhoneXBottomView.anchor(top: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
	}
	
	func removeBottomView() {
		iPhoneXBottomView.removeFromSuperview()
	}
	
	let buttonContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	override public var prefersStatusBarHidden: Bool { return isIphoneX() ? false : true }
	
	override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	public override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("\n!!!!!!!!!!!!!!!!!!!!!! Memory warning !!!!!!!!!!!!!!!!!!!!\n")
	}
	
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupViews()
		
		viewModel?.linesChanged = { [weak self] (lines) in
			self?.subtitleCollectionView.reloadData()
		}
		
		viewModel?.currentTextChanged = { [unowned self] (currentText) in
			self.subtitleLabel.text = currentText
		}
		
		viewModel?.currentSubtitleChanged = { [unowned self] (subtitleValid, subtitleCount, lineCount) in
			print(subtitleValid ? "subtitle valid" : "subtitle not valid", lineCount, "lines")
			self.fileInfoLabel.numberOfLines = 0
			if subtitleValid {
				self.fileInfoLabel.configure(fontSize: 11.dynamicSize(), bold: true, textColor: .themeGreen, lineCount: 0, alignment: .center)
				self.fileInfoLabel.text = "当前srt文件\n\(lineCount)条字幕"
			} else {
				self.fileInfoLabel.configure(fontSize: 11.dynamicSize(), bold: false, textColor: .gray128, lineCount: 0, alignment: .center)
				self.fileInfoLabel.text = "无srt文件"
			}
			self.switchButton.setEnabled(subtitleCount > 1 ? true : false)
		}
		
		viewModel?.linesToRemoveChanged = { [unowned self] (linesToRemove) in
			self.deleteSelectedButton.setEnabled(linesToRemove.count > 0 ? true : false)
		}
		
		viewModel?.observeSubtitles()
		
	}
	
	func setupViews() {
		
		view.addSubview(playerView)
		
		playerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width*9/16)
		
		playerView.addSubview(subtitleLabel)
		subtitleLabel.anchor(top: nil, left: playerView.leftAnchor, bottom: playerView.bottomAnchor, right: playerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 24, paddingRight: 10, width: 0, height: 0)
		
		view.addSubview(buttonContainerView)
		
		buttonContainerView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30.dynamicHeight())
		
		view.addSubview(subtitleCollectionView)
		
		subtitleCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: buttonContainerView.topAnchor, right: view.rightAnchor, paddingTop: view.frame.width*9/16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)


		view.addSubview(lineEditor)
		
		if self.isIphoneX() { addStatusBarView() }
		
		view.bringSubviewToFront(playerView)
	}
	
	fileprivate func unselectCells() {
		subtitleCollectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
			let cell = subtitleCollectionView.cellForItem(at: indexPath) as! SubtitleLineCell
			subtitleCollectionView.deselectItem(at: indexPath, animated: true)
			cell.removeSelectedView()
			cell.isSelected = false
		})
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfLines
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SubtitleLineCell
		cell.viewModel = viewModel.viewModelForLine(at: indexPath.item)
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let frame = CGRect(x: 0, y: 0, width: subtitleCollectionView.frame.width, height: 35)
		let dummyCell = SubtitleLineCell(frame: frame)
		dummyCell.viewModel = viewModel?.viewModelForLine(at: indexPath.item)
		dummyCell.layoutIfNeeded()
		let targetSize = CGSize(width: subtitleCollectionView.frame.width, height: 1000)
		let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
		let height = max(35, estimatedSize.height)
		return CGSize(width: subtitleCollectionView.frame.width, height: height)
	}
	
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if mode == .editLine {
			
			viewModel.pauseIfPlaying()
			
			lineEditor.viewModel.mode = .editLine
			
			lineEditor.viewModel.line = self.viewModel.line(at: indexPath.item)
			
			lineEditor.fillBlanks()

			showLineEditor()

		} else if mode == .deleteLines {
			let cell = subtitleCollectionView.cellForItem(at: indexPath) as! SubtitleLineCell
			cell.addSelectedView()
			viewModel?.fillLinesToRemove(from: indexPath.item)
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if mode == .deleteLines {
			let cell = subtitleCollectionView.cellForItem(at: indexPath) as! SubtitleLineCell
			cell.removeSelectedView()
			viewModel?.removeFromLinesToRemove(at: indexPath.item)
		}
	}
	
	deinit {
		print("videoPlayController已经销毁")
	}
}

