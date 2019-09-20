//
//  LoginController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
	
	var viewModel: LoginViewModel!
	
	let logoContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .themeGreen
		let logoTextLabel = UILabel()
		logoTextLabel.backgroundColor = .themeGreen
		logoTextLabel.textColor = .white
		logoTextLabel.textAlignment = .center
		logoTextLabel.text = "SubtitlePro"
		logoTextLabel.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 100)
		logoTextLabel.lineBreakMode = .byTruncatingTail
		logoTextLabel.baselineAdjustment = .alignCenters
		logoTextLabel.numberOfLines = 1
		logoTextLabel.minimumScaleFactor = 0.1
		logoTextLabel.adjustsFontSizeToFitWidth = true
		
		view.addSubview(logoTextLabel)
		
		//logoTextLabel.anchor(width: 100, height: 100)
		logoTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.618).isActive = true
		logoTextLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
		logoTextLabel.center(in: view, x: true, y: true)
		return view
	}()
	
	func textField(for placeHolder: String, secure: Bool) -> UITextField {
		let tf = UITextField()
		tf.placeholder = placeHolder
		tf.isSecureTextEntry = secure
		tf.backgroundColor = .gray240
		tf.borderStyle = .roundedRect
		tf.tintColor = .themeGreen
		tf.textColor = .gray64
		tf.delegate = self
		tf.addTarget(self, action: #selector(editingDidChange), for: .editingChanged)
		return tf
	}
	
	lazy var passwordTextField = textField(for: "密码", secure: true)
	lazy var usernameTextField = textField(for: "用户名", secure: false)
	
	lazy var buttonArray = [loginButton, dontHaveAccountButton]
	
	func allButtonsEnable(_ enable: Bool) {
		buttonArray.forEach { (button) in
			button.setEnabled(enable)
		}
	}
	
	let loginButton: UIButton = {
		let button = UIButton()
		button.configure(title: "登录", color: .white, bgColor: .themeGreen, image: nil, cornerRadius: 5)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 16)
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		button.setEnabled(false)
		return button
	}()
	
	@objc func handleLogin() {
		guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
		guard let password = passwordTextField.text else { return }
				
		if username.isEmpty || password.isEmpty {
			usernameTextField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [.foregroundColor: UIColor.themeRed])
			passwordTextField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [.foregroundColor: UIColor.themeRed])
			return
		} else {
			self.allButtonsEnable(false)
		}
		print("username: ", username)
		print("password: ", password)
		
		addAnimationView()
		
		viewModel.login(username: username, password: password)
	}
	
	let dontHaveAccountButton: UIButton = {
		let button = UIButton()
		let attributedTitle = NSMutableAttributedString(string: "还没有账户？", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
		attributedTitle.append(NSAttributedString(string: "注册账户", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.themeGreen]))
		button.setAttributedTitle(attributedTitle, for: .normal)
		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()
	
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
	
	func addAnimationView() {
		let animationView = WaitingAnimationView()
		view.addSubview(animationView)
		animationView.anchor(top: dontHaveAccountButton.bottomAnchor, left: dontHaveAccountButton.leftAnchor, bottom: nil, right: dontHaveAccountButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
		view.superview?.bringSubviewToFront(animationView)
		animationView.addBar()
		animationView.moveRight()
	}
	
	func removeAnimationView() {
		view.subviews.forEach { (view) in
			if view is WaitingAnimationView {
				view.removeFromSuperview()
			}
		}
	}
	
	@objc func handleShowSignUp() {
		let signupController = SignUpViewController()
		signupController.viewModel = SignUpViewModel()
		navigationController?.pushViewController(signupController, animated: true)
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		hideKeyBoardWhenTappedAround()
		
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
		view.backgroundColor = .white
		navigationController?.isNavigationBarHidden = true
		view.addSubview(logoContainerView)
		logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		logoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.23).isActive = true
		
		let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, loginButton, dontHaveAccountButton])
		
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fillEqually
		
		let stackViewHeight: CGFloat = 190
		view.addSubview(stackView)
		if UIDevice.current.userInterfaceIdiom == .pad {
			stackView.anchor(width: 350, height: stackViewHeight)
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		} else if UIDevice.current.userInterfaceIdiom == .phone {
			stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: stackViewHeight)
		}
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
		
		view.addSubview(willSignUpLaterButton)
		willSignUpLaterButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 180, height: 30)
		willSignUpLaterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
}

extension LoginController: UITextFieldDelegate {
	
	@objc func editingDidChange() {
		
		if let username = usernameTextField.text, !username.isEmpty,
			let password = passwordTextField.text, !password.isEmpty,
		username.count >= 6, password.count >= 6 {
			self.allButtonsEnable(true)
		} else {
			self.allButtonsEnable(false)
		}
		
	}
	
}
