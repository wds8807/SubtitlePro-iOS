//
//  ImageSelectorController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/30/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit
import Photos

protocol ImageSelectorDelegate: NSObjectProtocol {
	func imageSelectorController(_ picker: ImageSelectorController, didFinishPickingWith viewModel: ImageSelectorViewModel)
}

class ImageSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	weak var delegate: ImageSelectorDelegate?
	
	var viewModel: ImageSelectorViewModel!
	
	let cellID = "cell ID"
		
	var selectedIndexPath: IndexPath? {
		didSet {
			print(selectedIndexPath ?? " nil ")
		}
	}
	
	override var prefersStatusBarHidden: Bool { return true }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.setNeedsStatusBarAppearanceUpdate()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		collectionView?.alwaysBounceVertical = true
		
		collectionView?.register(ImageSelectorCell.self, forCellWithReuseIdentifier: cellID)
		
		setupNavigationButtons()
		
		viewModel?.didSelectImage = { [unowned self] (selectedImage) in
			print("Image selected: ", selectedImage != nil)
			self.navigationItem.rightBarButtonItem?.isEnabled = selectedImage == nil ? false : true
		}
		
		viewModel?.reloadUI = { [unowned self]  in
			DispatchQueue.main.async {
				self.collectionView?.reloadData()
			}
		}
		viewModel?.tryFetchPhotos()
	}
	
	func setupNavigationButtons() {
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .plain, target: self, action: #selector(handleUse))
		navigationItem.rightBarButtonItem?.isEnabled = false
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
		unselectCells()
	}
	
	@objc func handleUse() {
		delegate?.imageSelectorController(self, didFinishPickingWith: self.viewModel)
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageSelectorCell
		cell.viewModel = viewModel.viewModel(for: indexPath.item)
		if indexPath == self.selectedIndexPath {
			cell.addSelectedView()
		} else {
			cell.removeSelectedView()
		}

		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		self.selectedIndexPath = indexPath
		viewModel.selectAsset(at: indexPath.item)
		let cell = collectionView.cellForItem(at: indexPath) as! ImageSelectorCell
		cell.addSelectedView()
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? ImageSelectorCell {
			cell.removeSelectedView()
			self.selectedIndexPath = nil
		} else {
			collectionView.reloadItems(at: [indexPath])
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width-3) / 4
		return CGSize(width: width, height: width)
	}
	
	func unselectCells() {
		if let indexPaths = collectionView?.indexPathsForSelectedItems {
			for indexPath in indexPaths {
				guard let cell = collectionView?.cellForItem(at: indexPath) as? ImageSelectorCell else { return }
				collectionView?.deselectItem(at: indexPath, animated: true)
				cell.removeSelectedView()
			}
		}
	}
}





