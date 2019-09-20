//
//  UserProfileController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	var viewModel: UserProfileViewModel?
	
	let headerID = "headreID"
	let cellID = "cellID"
	
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
	
	let fullImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.frame = UIScreen.main.bounds
		imageView.backgroundColor = .black
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return fullImageView
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.contentInsetAdjustmentBehavior = .never

		collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		collectionView?.backgroundColor = .white
		collectionView?.alwaysBounceVertical = true
		collectionView?.register(ProfileContentCell.self, forCellWithReuseIdentifier: cellID)

		collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
	
		viewModel?.menuItemChanged = { [unowned self] (_) in
			self.collectionView?.reloadData()
		}
		
		viewModel?.reloadPage = { [unowned self] (profileImageURL) in
			self.collectionView?.reloadData()
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(viewModel?.numberOfItems ?? 0)
		return viewModel?.numberOfItems ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProfileContentCell
		cell.viewModel = viewModel?.viewModel(for: indexPath.item)
		return cell
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		guard let item = viewModel?.item(at: indexPath.item) else { return }
		
		if item == .signOut {
			
			confirmation.show(with: .signOut)
			
		}
		if item == .login {
			let loginController = LoginController()
			loginController.viewModel = LoginViewModel()
			let nav = UINavigationController(rootViewController: loginController)
			present(nav, animated: true)
		}
		
		if item == .posts {
//			let postListsController = PostsListController(collectionViewLayout: UICollectionViewFlowLayout())
//			postListsController.viewModel = viewModel?.postListViewModel()
//			postListsController.hidesBottomBarWhenPushed = true
//			navigationController?.pushViewController(postListsController, animated: true)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = min(view.frame.height/10, 45)
		return CGSize(width: view.frame.width, height: height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		print(indexPath)
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! HeaderView
		header.profileImageView.image = nil
		header.delegate = self
		header.viewModel = self.viewModel
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: view.frame.height/2)
	}
}

extension UserProfileController: HeaderViewDelegate {
	
	func headerView(_ headerView: HeaderView, profileImageViewPressed profileImageView: CustomImageView, sender: UIGestureRecognizer) {
		guard let viewModel = viewModel else { return }
		guard viewModel.isCurrentUser else { return }
		guard let _ = profileImageView.image else { return }
		guard let oldImageView = sender.view as? UIImageView else { return }
		fullImageView.image = oldImageView.image
		guard let window = UIApplication.shared.keyWindow else { return }
		let scrollView = UIScrollView()
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0
		scrollView.frame = UIScreen.main.bounds
		scrollView.delegate = self
		scrollView.addSubview(fullImageView)
		window.addSubview(scrollView)
		scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage(sender:))))
	}
	
	@objc func dismissFullScreenImage(sender: UITapGestureRecognizer) {
		sender.view?.removeFromSuperview()
	}
	
	func headerView(_ headerView: HeaderView, profileImageViewLongPressed profileImageView: CustomImageView) {
		menu.delegate = self
		menu.show(items: [MenuItem.editProfilePhoto, MenuItem.cancel])
	}
}

extension UserProfileController: MenuDelegate {
	
	func menu(_ menu: Menu, didSelect item: String) {
		
		guard item == MenuItem.editProfilePhoto else { return }
		
		let imageSelectorController = ImageSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
		imageSelectorController.viewModel = ImageSelectorViewModel()
		imageSelectorController.delegate = self
		let navController = UINavigationController(rootViewController: imageSelectorController)
		navController.navigationBar.isTranslucent = false
		navController.navigationBar.barTintColor = .themeGreen
		navController.navigationBar.tintColor = .white
		navController.navigationBar.barStyle = .black
		present(navController, animated: true, completion: nil)
	}
	
	func menu(_ menu: Menu, didTapBlackView blackView: UIView) {
		menu.handleDismiss2()
	}
}

extension UserProfileController: ImageSelectorDelegate {
	func imageSelectorController(_ picker: ImageSelectorController, didFinishPickingWith viewModel: ImageSelectorViewModel) {
		
		picker.navigationItem.rightBarButtonItem?.isEnabled = false
		
		guard let image = viewModel.getSelectedImage() else { return }
		
		self.viewModel?.upload(image: image, completion: { (success) in
			if success {
				picker.unselectCells()
				if let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView {
					if let data = image.jpegData(compressionQuality: 0.1) {
						let smallImage = UIImage(data: data)
						header.profileImageView.image = smallImage
					}
				}
				picker.dismiss(animated: true, completion: nil)
			} else {
				picker.navigationItem.rightBarButtonItem?.isEnabled = true
			}
		})
	}
}

extension UserProfileController: ConfirmationDelegate {
	
	func confirmation(_ confirmation: Confirmation, action: ActionToConfirm) {
		
		guard action == .signOut else { return }
		
		User.currentUser = nil
		let loginController = LoginController()
		loginController.viewModel = LoginViewModel()
		let nav = UINavigationController(rootViewController: loginController)
		present(nav, animated: true)
		UserDefaults.standard.removeObject(forKey: Keys.savedUser)
		if let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView {
			header.profileImageView.image = nil
		}
	}
}
	
	

