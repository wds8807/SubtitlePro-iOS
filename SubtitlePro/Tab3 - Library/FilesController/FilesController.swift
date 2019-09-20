//
//  LibraryController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

enum SelectMode {
	case normal, delete
}

class FilesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	private let videoCellID = "video cell"
	private let subtitleCellID = "subtitle cell"
	
	let loadingFilesLabel: UILabel = {
		let label = UILabel()
		label.configure(fontSize: 16, bold: false, textColor: .gray128, lineCount: 0, alignment: .center)
		label.text = "Loading files..."
		return label
	}()
	
	var mode: SelectMode = .normal {
		didSet {
			if mode == .normal {
				collectionView?.allowsSelection = true
				collectionView?.allowsMultipleSelection = false
				let pickBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickFile))
				let selectBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectVideos))
				navigationItem.rightBarButtonItems = [pickBtn, selectBtn]
				navigationItem.leftBarButtonItems = []
				selectBtn.isEnabled = viewModel.numberOfMedia > 0 ? true : false
			} else if mode == .delete {
				collectionView?.allowsSelection = true
				collectionView?.allowsMultipleSelection = true
				let deleteBtn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
				let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDelete))
				deleteBtn.isEnabled = false
				navigationItem.rightBarButtonItems = [deleteBtn]
				navigationItem.leftBarButtonItems = [cancelBtn]
			}
		}
	}
	
	var viewModel: FilesViewModel!
	
	lazy var confirmation: Confirmation = {
		let c = Confirmation()
		c.delegate = self
		return c
	}()
	
	
	fileprivate func setupNavigationItems() {
		navigationItem.title = "Library"
		let pickBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickFile))
		let selectBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectVideos))
		navigationItem.rightBarButtonItems = [pickBtn, selectBtn]
	}
	
	@objc func pickFile() {
		let viewModel = MediaSelectorViewModel()
		viewModel.purpose = .toImport
		viewModel.fetchLocation = .photoLibrary
		let mediaSelectorController = MediaSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
		mediaSelectorController.delegate = self
		mediaSelectorController.viewModel = viewModel
		let navController = UINavigationController(rootViewController: mediaSelectorController)
		navController.navigationBar.isTranslucent = false
		navController.navigationBar.barTintColor = .themeGreen
		navController.navigationBar.barStyle = .black
		navController.navigationBar.tintColor = .white
		
		present(navController, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		
		viewModel = FilesViewModel()
		
		viewModel.reloadUI = { [unowned self] (count) in
			DispatchQueue.main.async {
				self.loadingFilesLabel.removeFromSuperview()
				self.reloadUI(mediaCount: count)
			}
		}
		
		viewModel.loading = { [unowned self] in
			DispatchQueue.main.async {
				self.collectionView.addSubview(self.loadingFilesLabel)
				self.loadingFilesLabel.frame = self.collectionView.bounds
			}
		}
		
		viewModel.loadFiles()
		
	}
	
	fileprivate func reloadUI(mediaCount: Int) {
		self.collectionView.reloadData()
		guard let selectButton = self.navigationItem.rightBarButtonItems?.last else { return }
		selectButton.isEnabled = mediaCount > 0 ? true : false
	}
	
	func setupViews() {
		
		collectionView.backgroundColor = .gray240
		collectionView.allowsSelection = true
		collectionView.allowsMultipleSelection = false
		collectionView.alwaysBounceVertical = true
		collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellID)
		collectionView.register(SubtitleFileCell.self, forCellWithReuseIdentifier: subtitleCellID)
		setupNavigationItems()
	}
	
	@objc func selectVideos() {
		mode = .delete
	}
	
	@objc func handleDelete() {
		confirmation.show(with: .deleteVideo)
	}
	
	@objc func cancelDelete() {
		
		collectionView.indexPathsForSelectedItems?.forEach { (indexPath) in
			if let cell = collectionView.cellForItem(at: indexPath) as? VideoCell {
				cell.isSelected = false
				cell.removeSelectedView()
			} else {
				collectionView.reloadItems(at: [indexPath])
			}
		}
		mode = .normal
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfMedia
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellID, for: indexPath) as! VideoCell
		
		cell.viewModel = viewModel.viewModelForMedium(at: indexPath.item)
		
		if let indexPaths = collectionView.indexPathsForSelectedItems {
			if indexPaths.contains(indexPath) {
				cell.addSelectedView()
			} else {
				cell.removeSelectedView()
			}
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.bounds.width, height: 70)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
	}
	
	var lastPlayedIndexPath: IndexPath?
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if mode == .normal {
			// play video on videoPlayController
			
			let videoPlayController = VideoPlayController()
			videoPlayController.mode = .none
			videoPlayController.filesController = self
			if let viewModel = viewModel.videoPlayViewMode(at: indexPath.item) {
				videoPlayController.viewModel = viewModel
				videoPlayController.hidesBottomBarWhenPushed = true
				navigationController?.pushViewController(videoPlayController, animated: true)
				lastPlayedIndexPath = indexPath
			}
			
		} else if mode == .delete {
			let cell = collectionView.cellForItem(at: indexPath) as! VideoCell
			navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems?.count ?? 0 > 0 ? true : false
			viewModel.selectMediumToDelete(at: indexPath.item)
			cell.addSelectedView()
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		guard mode == .delete else { return }
		
		let cell = collectionView.cellForItem(at: indexPath) as! VideoCell
		cell.removeSelectedView()
		navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems?.count ?? 0 > 0 ? true : false
	}
}

extension FilesController: ConfirmationDelegate {
	
	func confirmation(_ confirmation: Confirmation, action: ActionToConfirm) {
		
		guard action == .deleteVideo else { return }
		
		viewModel.deleteSelectedMedia()
		cancelDelete()
		viewModel.loadFiles()
	}
}

extension FilesController: MediaSelectorDelegate {
	
	func importFinished(success: Bool) {
		if success {
			self.viewModel.loadFiles()
		}
	}
	
	func didInitiateUpload() {
		// do nothing
	}
}

extension FilesController: VideoPlayerDelegate {
	
	func playerDidClose(_ player: VideoPlayerView) {
		guard let indexPath = self.lastPlayedIndexPath else { return }
		guard let cellViewModel = self.viewModel.viewModelForMedium(at: indexPath.item) else { return}
		
		guard let cell = collectionView.cellForItem(at: indexPath) as? VideoCell else { return }
		cell.viewModel = cellViewModel
	}
}
