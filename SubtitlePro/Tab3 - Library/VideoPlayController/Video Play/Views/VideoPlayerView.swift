//
//  VideoPlayerView
//  LocalView
//
//  Created by Dongshuo Wu on 6/6/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import AVFoundation
import UIKit

protocol VideoPlayerDelegate: NSObjectProtocol {
	func playerDidClose(_ player: VideoPlayerView)
}

public class VideoPlayerView: UIView {
	
	weak var delegate: VideoPlayerDelegate?

	var viewModel: VideoPlayViewModel! {
		didSet {
			print("view model did set", viewModel == nil)
			guard viewModel != nil else { return }
			viewModel.pausePlayStatusChanged = { [weak self] (isPlaying) in
				if isPlaying {
					self?.pausePlayBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
				} else {
					self?.pausePlayBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
				}
			}
			
			viewModel.playTimeDidChange = { [weak self] (currentSliderValue) in
				self?.videoSlider.value = currentSliderValue
			}
			viewModel.progressTimeDidChange = { [weak self] (progressTime) in
				self?.currentTimeLabel.text = progressTime.cmTimeString
			}
			
			viewModel.durationObserved = { [weak self] (duration) in
				self?.videoLengthLabel.text = duration.cmTimeString
			}
			
			viewModel.loadedTimeProgressDidChange = { [weak self] (loadedTime) in
				self?.progressView.progress = loadedTime
			}
			
			viewModel.loadingStatusChanged = { [weak self] (loadingFinished) in
				if loadingFinished {
					self?.activityIndicatorView.stopAnimating()
					self?.pausePlayBtn.isHidden = false
				} else {
					self?.activityIndicatorView.startAnimating()
					self?.pausePlayBtn.isHidden = true
				}
			}
			
			viewModel.playingStatusChanged = { [weak self] (playingFinished) in
				if playingFinished {
					self?.pausePlayBtn.setImage(UIImage(named: "replay"), for: .normal)
					self?.containerViewSetHidden(false)
				}
			}
		}
	}
	
	weak var videoPlayController: VideoPlayController?
	
	
	
	//var isPlaying = true
	//var isSliding = false
	var isFullScreen = false {
		didSet {
			fullScreenImageView.image = isFullScreen ? #imageLiteral(resourceName: "full_screen_exit") : #imageLiteral(resourceName: "full_screen")
		}
	}
	var containerViewIsHidden = false
	
	let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.1, alpha: 0.4)
		return view
	}()
	
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .whiteLarge)
		aiv.translatesAutoresizingMaskIntoConstraints = false
		aiv.startAnimating()
		return aiv
	}()
	
	var playerLayer: AVPlayerLayer?
	
	lazy var pausePlayBtn: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .white
		button.isHidden = false
		button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
		return button
	}()
	
	lazy var closeBtn: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .white
		button.isHidden = false
		button.addTarget(self, action: #selector(handleCloseVideoController), for: .touchUpInside)
		return button
	}()
	
	// This is the source of a stupid mistake:
	// I was trying to connect the action of the trigger view
	// but the trigger parameter of the action method is not the type of the trigger
	lazy var fullScreenTriggerView: UIView = {
		let view = UIView()
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFullScreen)))
		return view
	}()
	
	lazy var fullScreenImageView: UIImageView = {
		let iv = UIImageView()
		iv.image = isFullScreen ? #imageLiteral(resourceName: "full_screen_exit") : #imageLiteral(resourceName: "full_screen")
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()
	
	let videoLengthLabel: UILabel  = {
		let label = UILabel()
		label.text = "0:00"
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .right
		label.baselineAdjustment = .alignCenters
		return label
	}()
	
	let currentTimeLabel: UILabel = {
		let label = UILabel()
		label.text = "0:00"
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 14)
		label.textAlignment = .left
		label.baselineAdjustment = .alignCenters
		
		return label
	}()
	
	lazy var videoSlider: UISlider = {
		let slider = UISlider()
		slider.minimumTrackTintColor = .themeBlue
		slider.maximumTrackTintColor = UIColor(white: 1, alpha: 0.5)
		slider.setThumbImage(UIImage(named: "thumbBlue30"), for: .normal)
		
		// Touch down
		slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
		// Touch release
		slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
		slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpOutside)
		slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchCancel)
		slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
		
		return slider
	}()
	
	let progressView: UIProgressView = {
		let p = UIProgressView()
		p.trackTintColor = .clear
		p.progressTintColor = UIColor(white: 1, alpha: 0.75)
		return p
	}()
	
	@objc func handleFullScreen(_ triggerView: UIView) {
		//delegate?.videoPlayer(self, fullScreenView: triggerView)
		if !self.isFullScreen {
			self.translatesAutoresizingMaskIntoConstraints = true
			videoPlayController?.addBottomView()
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.videoPlayController?.subtitleLabel.font = .boldSystemFont(ofSize: UI_USER_INTERFACE_IDIOM() == .pad ? 42 : 28)
				self.transform = CGAffineTransform(rotationAngle: .pi/2)
				
				if self.isIphoneX() {
					self.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-78)
				} else {
					self.frame = UIScreen.main.bounds
				}
			}, completion: nil)
			
		} else {
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.videoPlayController?.subtitleLabel.font = .boldSystemFont(ofSize: UI_USER_INTERFACE_IDIOM() == .pad ? 30 : 15)
				let width = UIScreen.main.bounds.width
				let height = width*9/16
				self.transform = CGAffineTransform(rotationAngle: 0)
				
				
				if self.isIphoneX() {
					self.frame = CGRect(x: 0, y: 44, width: width, height: height)
				} else {
					self.frame = CGRect(x: 0, y: 0, width: width, height: height)
				}
			}, completion: { (_) in
				self.videoPlayController?.removeBottomView()
			})
		}
		
		self.isFullScreen = !self.isFullScreen
		layoutSlider(fullScreen: isFullScreen)
	}
	
	@objc func handlePause(_ pausePlayBtn: UIButton) {
		viewModel.handlePause()
	}

	@objc func sliderTouchUp(_ slider: UISlider) {

		self.activityIndicatorView.startAnimating()
		viewModel?.sliderTouchUp(sliderValue: slider.value, {
			self.activityIndicatorView.stopAnimating()
		})
		
	}
	
	@objc func sliderTouchDown(_ slider: UISlider) {
		viewModel?.isSliding = true
	}
	
	@objc func handleSliderChange(_ slider: UISlider) {
		currentTimeLabel.text = viewModel?.labelText(for: slider.value)
	}
	
	@objc func handleCloseVideoController(_ closeBtn: UIButton) {
		videoPlayController?.navigationController?.popViewController(animated: true)
		
		viewModel.stopPlaying()
		viewModel = nil 
		
		delegate?.playerDidClose(self)
	}
	
	@objc func handlecontainerViewHide() {
		
		containerViewSetHidden(!containerViewIsHidden)

	}
	
	fileprivate func containerViewSetHidden(_ hidden: Bool) {
		containerView.isHidden = hidden
		videoSlider.setThumbImage(hidden ? UIImage() : UIImage(named: "thumbBlue30"), for: .normal)
		containerViewIsHidden = hidden
	}
	
	func setupVideoControlView() {
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlecontainerViewHide)))
		
		addSubview(activityIndicatorView)
		activityIndicatorView.center(in: self, x: true, y: true)
		
		addSubview(containerView)
		containerView.anchorNoSpacing(with: self)
		containerView.addSubview(pausePlayBtn)
		pausePlayBtn.anchor(width: 40, height: 40)
		pausePlayBtn.center(in: containerView, x: true, y: true)
		containerView.addSubview(fullScreenTriggerView)
		fullScreenTriggerView.anchor(top: nil, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 55, height: 55)
		fullScreenTriggerView.addSubview(fullScreenImageView)
		fullScreenImageView.center(in: fullScreenTriggerView, x: true, y: true)
		fullScreenImageView.anchor(width: 15, height: 15)
		containerView.addSubview(videoLengthLabel)
		videoLengthLabel.anchor(top: nil, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 55, width: 45, height: 15)
		containerView.addSubview(currentTimeLabel)
		currentTimeLabel.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 45, height: 15)
	
		
		self.clipsToBounds = false
		
		
		layoutSlider(fullScreen: isFullScreen)
		
		containerView.addSubview(closeBtn)
		closeBtn.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
		
	}
	
	fileprivate func layoutSlider(fullScreen: Bool) {
		
		if (!isFullScreen) {
			
			videoSlider.removeFromSuperview()
			progressView.removeFromSuperview()
			
			self.addSubview(videoSlider)
			self.insertSubview(progressView, belowSubview: videoSlider)
			
			
			videoSlider.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -6, paddingRight: 0, width: 0, height: 15)
			
			progressView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
		} else {
			
			videoSlider.removeFromSuperview()
			progressView.removeFromSuperview()
			
			containerView.addSubview(videoSlider)
			containerView.insertSubview(progressView, belowSubview: videoSlider)
			
			videoSlider.anchor(top: nil, left: currentTimeLabel.rightAnchor, bottom: containerView.bottomAnchor, right: videoLengthLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 15)
			
			progressView.anchor(top: nil, left: videoSlider.leftAnchor, bottom: nil, right: videoSlider.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
			progressView.center(in: videoSlider, offsetX: 0, offsetY: 0.5)
		}
		
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		playerLayer?.frame = self.bounds
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		clipsToBounds = true
		setupVideoControlView()
		isFullScreen = false
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("video Player view deinit() called.")
		viewModel?.stopPlaying()
	}
}





