//
//  MediaSelectorController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

protocol MediaSelectorDelegate: NSObjectProtocol {
	func importFinished(success: Bool)
	func didInitiateUpload()
}

class MediaSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	var viewModel: MediaSelectorViewModel!

	weak var delegate: MediaSelectorDelegate?

	var currentSelectedIndexPath: IndexPath?
	var oldSelectedIndexPath: IndexPath?

	let cellID = "cellID"

	override var prefersStatusBarHidden: Bool { return true }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setNeedsStatusBarAppearanceUpdate()
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = viewModel.backgroundColor
		collectionView.alwaysBounceVertical = true
		collectionView.allowsMultipleSelection = false
		collectionView.register(MediaSelectorCell.self, forCellWithReuseIdentifier: cellID)
		
		setupNavigationBar()
		
		viewModel.reloadUI = { [weak self] in

			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
		
		viewModel.exportFinished = { [unowned self] (success) in
			DispatchQueue.main.async {
				if success {
					self.dismiss(animated: true, completion: nil)
					InfoView.show(message: InfoLiterals.importSuccess, success: true)
				} else {
					self.navigationItem.rightBarButtonItem?.isEnabled = true
					InfoView.show(message: InfoLiterals.importFail, success: false)
				}
				self.delegate?.importFinished(success: success)
			}
		}
		
		viewModel.mediumSelected = { [unowned self] (mediumValid) in
			DispatchQueue.main.async {
				self.navigationItem.rightBarButtonItem?.isEnabled = mediumValid
			}
		}
		
		viewModel?.fetchAVURLVideos()
	}


	fileprivate func unselectCells() {
		if let indexPaths = collectionView?.indexPathsForSelectedItems {
			for indexPath in indexPaths {
				let cell = collectionView?.cellForItem(at: indexPath) as! MediaSelectorCell
				collectionView?.deselectItem(at: indexPath, animated: true)
				cell.removeSelectedView()
			}
		}
	}

	fileprivate func setupNavigationBar() {

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancel))
		let importButton = UIBarButtonItem(title: "导入", style: .plain, target: self, action: #selector(handleImport))
		let nextButton = UIBarButtonItem(title: "继续", style: .plain, target: self, action: #selector(handleNext))
		guard let purpose = viewModel.purpose else { return }
		navigationItem.rightBarButtonItem = purpose == .toImport ? importButton : nextButton
		navigationItem.rightBarButtonItem?.isEnabled = false
	}

	@objc func handleNext() {
		
		guard let medium = viewModel.selectedMedium else { return }
		
		let playerViewModel = VideoPlayViewModel(medium: medium)
		
		let uploadController = UploadController()
		
		let uploadViewModel = UploadViewModel(medium: medium)
		uploadViewModel.uploadController = uploadController
		uploadController.viewModel = uploadViewModel
		uploadController.playerViewModel = playerViewModel
		
		oldSelectedIndexPath = currentSelectedIndexPath
		navigationController?.pushViewController(uploadController, animated: true)

	}

	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}

	@objc func handleImport() {
		navigationItem.rightBarButtonItem?.isEnabled = false
		if let indexPath = currentSelectedIndexPath {
			viewModel.exportAsset(at: indexPath.item)
		}
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MediaSelectorCell

		cell.viewModel = viewModel.cellViewModel(at: indexPath.item)

		if indexPath == self.currentSelectedIndexPath {
			cell.addSelectedView()
		} else {
			cell.removeSelectedView()
		}
		
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("selection works")
		self.currentSelectedIndexPath = indexPath
		
		viewModel.selectMedium(at: indexPath.item)

		let cell = collectionView.cellForItem(at: indexPath) as! MediaSelectorCell
		cell.addSelectedView()
		
		guard let oldSelectedIndexPath = oldSelectedIndexPath else { return }
		
		if oldSelectedIndexPath != currentSelectedIndexPath {
			if let cell = collectionView.cellForItem(at: oldSelectedIndexPath) as? MediaSelectorCell {
				cell.removeSelectedView()
				
			} else {
				collectionView.reloadItems(at: [oldSelectedIndexPath])
			}
		}
	}

	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		if let cell = collectionView.cellForItem(at: indexPath) as? MediaSelectorCell {
			cell.removeSelectedView()
			
		} else {
			collectionView.reloadItems(at: [indexPath])
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let side = isPad() ? (view.frame.width-3)/4 : (view.frame.width-2)/3
		return CGSize(width: side, height: side)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
	}

}
