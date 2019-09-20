//
//  SignUpViewController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIScrollViewDelegate {
	
	var viewModel: SignUpViewModel!
	
	var userHasSelectedProfileImage = false
	
	lazy var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.delegate = self
		scroll.alwaysBounceVertical = true
		scroll.backgroundColor = .white
		let statusHeight = UIApplication.shared.statusBarFrame.height
		let height = UIScreen.main.bounds.height - statusHeight
		scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
		scroll.keyboardDismissMode = .onDrag
		return scroll
	}()
	
	let contentView = UIView()
	
	let usernameChecker: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textAlignment = .right
		label.sizeToFit()
		return label
	}()
	
	let warningTextView: UITextView = {
		let tv = UITextView()
		tv.configure(fontSize: 14, bold: false, textColor: .themeRed, borderColor: .clear, borderWidth: 0, cornerRadius: 0)
		tv.isUserInteractionEnabled = false
		return tv
	}()
	
	let addPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "addPhoto"), for: .normal)
		button.tintColor = .themeGreen
		button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
		button.layer.masksToBounds = true
		return button
	}()
	
	@objc func handleAddPhoto() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func textField(for placeHolder: String, secure: Bool) -> UITextField {
		let tf = UITextField()
		tf.placeholder = placeHolder
		tf.isSecureTextEntry = secure
		tf.backgroundColor = .gray240
		tf.borderStyle = .roundedRect
		tf.tintColor = .themeGreen
		tf.textColor = .gray64
		tf.delegate = self
		tf.addTarget(self, action: #selector(editingDidChange(sender:)), for: .editingChanged)
		return tf
	}
	
	lazy var usernameTextField = textField(for: "用户名", secure: false)
	lazy var emailTextField = textField(for: "Email", secure: false)
	lazy var passwordTextField = textField(for: "密码", secure: true)
	lazy var confirmPasswordTextField = textField(for: "确认密码", secure: true)
	
	lazy var signUpButton: UIButton = {
		let button = UIButton()
		button.setTitle("注册", for: .normal)
		button.backgroundColor = .themeGreen
		button.layer.cornerRadius = 5
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
		button.setEnabled(false)
		return button
	}()
	
	lazy var buttonArray = [signUpButton, alreadyHaveAccountButton, willSignUpLaterButton]
	
	func allButtonsEnable(_ enable: Bool) {
		buttonArray.forEach { (button) in
			button.setEnabled(enable)
		}
	}
	
	var profileImage: UIImage?
	
	@objc func handleSignUp() {
		guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
		guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
		guard let password = passwordTextField.text else { return }
		
		self.allButtonsEnable(false)
		
		addAnimationView()
		
		viewModel.imageData = self.profileImage?.jpegData(compressionQuality: 0.075)
		
		viewModel.signUp(username: username, email: email, password: password)
	}
	
	func addAnimationView() {
		let view = WaitingAnimationView()
		contentView.addSubview(view)
		view.anchor(top: alreadyHaveAccountButton.bottomAnchor, left: alreadyHaveAccountButton.leftAnchor, bottom: nil, right: alreadyHaveAccountButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
		view.superview?.bringSubviewToFront(view)
		view.addBar()
		view.moveRight()
	}
	
	func removeAnimationView() {
		contentView.subviews.forEach { (view) in
			if view is WaitingAnimationView {
				view.removeFromSuperview()
			}
		}
	}
	
	let willSignUpLaterButton: UIButton = {
		let button = UIButton()
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.setTitleColor(.lightGray, for: .normal)
		button.setTitle("以后再说", for: .normal)
		button.addTarget(self, action: #selector(handleSignUpLater), for: .touchUpInside)
		return button
	}()
	
	@objc func handleSignUpLater() {
		self.dismiss(animated: true, completion: nil)
		guard let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
		main.setupViewControllers()
	}
	
	let alreadyHaveAccountButton: UIButton = {
		let button = UIButton()
		let attributedTitle = NSMutableAttributedString(string: "已经有账户？", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
		attributedTitle.append(NSAttributedString(string: "登录", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.themeGreen]))
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
		return button
	}()
	
	@objc func handleAlreadyHaveAccount() {
		navigationController?.popViewController(animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		hideKeyBoardWhenTappedAround()
		
		viewModel.warningChanged = { [unowned self] (warning) in
			self.warningTextView.text = warning
		}
		
		viewModel.checkerChanged = { [weak self] (status) in
		
			guard let strongSelf = self else { return }
			
			if strongSelf.reValidateUsername() {
				strongSelf.usernameChecker.text = status.rawValue
				switch status {
				case .checking:
					strongSelf.usernameChecker.textColor = .gray180
					break
				case .alreadyTaken:
					strongSelf.usernameChecker.textColor = .themeRed
					break
				case .available:
					strongSelf.usernameChecker.textColor = .themeGreen
					break
				case .internetError:
					strongSelf.usernameChecker.textColor = .themeRed
					break
				}
			}
			strongSelf.signUpButton.setEnabled(strongSelf.viewModel.formValid)
		}
		
		viewModel.updateUI = { [unowned self] (success) in
			if success {
				self.dismiss(animated: true, completion: {
					guard let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
					main.setupViewControllers()
					self.dismiss(animated: true, completion: nil)
				})
			} else {
				self.allButtonsEnable(true)
				self.removeAnimationView()
			}
		}
	}
	
	func setupViews() {
		
		let statusHeight = UIApplication.shared.statusBarFrame.height
		
		view.addSubview(scrollView)
		scrollView.frame = view.bounds
		
		scrollView.addSubview(contentView)
		contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: -statusHeight, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height)
		
		contentView.addSubview(willSignUpLaterButton)
		willSignUpLaterButton.anchor(top: nil, left: nil, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
		willSignUpLaterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		
		let stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, alreadyHaveAccountButton])
		
		usernameTextField.addSubview(usernameChecker)
		usernameChecker.anchor(top: usernameTextField.topAnchor, left: nil, bottom: usernameTextField.bottomAnchor, right: usernameTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 80, height: 0)
		
		stackView.distribution = .fillEqually
		stackView.axis = .vertical
		stackView.spacing = 10
		
		contentView.addSubview(stackView)
		contentView.addSubview(addPhotoButton)
		
		let stackViewHeight: CGFloat = 290
		
		stackView.center(in: contentView)
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			stackView.anchor(width: 350, height: stackViewHeight)
			
		} else {
			stackView.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: stackViewHeight)
		}
		
		let assistView = UIView()
		contentView.addSubview(assistView)
		assistView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: stackView.topAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		assistView.addSubview(addPhotoButton)
		
		let radius = view.frame.height / 12.5
		addPhotoButton.anchor(width: radius * 2, height: radius * 2)
		addPhotoButton.layer.cornerRadius = radius
		addPhotoButton.center(in: assistView, offsetX: 0, offsetY: 0)
		view.addSubview(warningTextView)
		warningTextView.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: willSignUpLaterButton.topAnchor, right: stackView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
	}
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let editedImage = info[.editedImage] as? UIImage {
			addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
			profileImage = editedImage
		} else if let originalImage = info[.originalImage] as? UIImage {
			addPhotoButton.setImage(originalImage, for: .normal)
			profileImage = originalImage
		}
		dismiss(animated: true, completion: nil)
		userHasSelectedProfileImage = true
	}
}

extension SignUpViewController: UITextFieldDelegate {
	
	func reValidateUsername() -> Bool {
		guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces) else { return false }
		return viewModel.validate(username: username)
	}
	
	@objc func editingDidChange(sender: UITextField) {
	
		guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces),
					let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
					let pw1 = passwordTextField.text?.trimmingCharacters(in: .whitespaces),
					let pw2 = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
		
		if sender == usernameTextField {
			if viewModel.validate(username: username) {
				viewModel.checkUsername(username: username)
			} else {
				usernameChecker.text = ""
			}
		}
		if sender == emailTextField { viewModel.validate(email: email) }
		if sender == passwordTextField || sender == confirmPasswordTextField {
			viewModel.validate(password: pw1)
			viewModel.passwordsMatch(pw1: pw1, pw2: pw2)
		}
		self.signUpButton.setEnabled(viewModel.formValid)
	}
	
}



