//
//  VideoPlayViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit
import AVFoundation

extension Keys {
	static let loadedTimeRanges = "loadedTimeRanges"
	static let status = "status"
	static let playbackBufferEmpty = "playbackBufferEmpty"
	static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
	static let playbackBufferFull = "playbackBufferFull"
}

let pauseVideoNotification = "pauseVideo"

class VideoPlayViewModel: NSObject {
	
	init(medium: Medium) {
		self.medium = medium
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(pauseIfPlaying), name: NSNotification.Name(rawValue: pauseVideoNotification), object: nil)
		
		let url = URL(fileURLWithPath: medium.path)
		configurePlayerLayer(with: url)
	}
	
	@objc func pauseIfPlaying() {
		if isPlaying {
			player?.pause()
			isPlaying = false
		}
	}

	var medium: Medium?
	var post: Post?
	
	var player: AVPlayer?
	var playerLayer: AVPlayerLayer?
	var playerItem: AVPlayerItem?
	
	var playTimeDidChange: ((Float) -> ())?
	var progressTimeDidChange: ((CMTime) -> ())?
	var durationObserved: ((CMTime) -> ())?
	var loadedTimeProgressDidChange: ((Float) -> ())?
	
	private var loadingFinished: Bool = false {
		didSet { loadingStatusChanged?(loadingFinished) }
	}
	
	var loadingStatusChanged:((Bool) -> ())?
	
	private var playingFinished: Bool = false {
		didSet { playingStatusChanged?(playingFinished) }
	}
	var playingStatusChanged: ((Bool) -> ())?
	
	var isSliding: Bool = false
	
	private var isPlaying: Bool = false {
		didSet {
			pausePlayStatusChanged?(isPlaying)
		}
	}
	
	var pausePlayStatusChanged: ((Bool) -> ())?
	
	func handlePause() {
		if isPlaying {
			player?.pause()
		} else {
			if playingFinished {
				player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 50000))
			}
			player?.play()
		}
		isPlaying = !isPlaying
		print(isPlaying ? "Now playing" : "Now paused")
	}
	
	func sliderTouchUp(sliderValue: Float, _ completion: @escaping() -> ()) {
		guard let duration = player?.currentItem?.duration else { return }
		let totalSeconds = CMTimeGetSeconds(duration)
		let value = sliderValue * Float(totalSeconds)
		let seekTime = CMTimeMakeWithSeconds(Float64(value), preferredTimescale: 50000)
		player?.seek(to: seekTime, completionHandler: { (_) in
			self.isSliding = false
			completion()
		})
	}
	
	func sliderTouchDown() {
		self.isSliding = true
	}
	
	func labelText(for sliderValue: Float) -> String {
		guard let duration = player?.currentItem?.duration else { return "0:-1" }
		let totalSeconds = CMTimeGetSeconds(duration)
		
		if totalSeconds.isNaN || totalSeconds.isInfinite { return "0:-1" }
		
		let value = sliderValue * Float(totalSeconds)
		let secondsString = String(format: "%02d", Int(value.truncatingRemainder(dividingBy: 60)))
		let minuteValue = Int(value/60)
		let minutesString = String(format: minuteValue < 10 ? "%01d" : "%02d", minuteValue)
		return "\(minutesString):\(secondsString)"
	}
	
	func configurePlayerLayer(with url: URL) {
		NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
		
		playerItem = AVPlayerItem(url: url)
		playerItem?.addObserver(self, forKeyPath: Keys.loadedTimeRanges, options: .new, context: nil)
		playerItem?.addObserver(self, forKeyPath: Keys.status, options: .new, context: nil)
		player = AVPlayer(playerItem: playerItem)
		playerItem?.addObserver(self, forKeyPath: Keys.playbackBufferEmpty, options: .new, context: nil)
		playerItem?.addObserver(self, forKeyPath: Keys.playbackLikelyToKeepUp, options: .new, context: nil)
		playerItem?.addObserver(self, forKeyPath: Keys.playbackBufferFull, options: .new, context: nil)
		playerLayer = AVPlayerLayer(player: player)
		playerLayer?.backgroundColor = UIColor.black.cgColor
		playerLayer?.videoGravity = .resizeAspect
		
		let interval = CMTime(value: CMTimeValue(1), timescale: 100)
		player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
			
			if !self.isSliding {
				self.progressTimeDidChange?(progressTime)
				if let duration = self.player?.currentItem?.duration {
					let durationSeconds = CMTimeGetSeconds(duration)
					let currentSeconds = CMTimeGetSeconds(progressTime)
					let currentSliderValue = Float(currentSeconds/durationSeconds)
					self.playTimeDidChange?(currentSliderValue)
				}
			}
		})
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		guard let playerItem = self.playerItem else { return }
		
		if keyPath == Keys.loadedTimeRanges {
			self.durationObserved?(playerItem.duration)
			let percentLoaded = loadedTime()/CMTimeGetSeconds(playerItem.duration)
			self.loadedTimeProgressDidChange?(Float(percentLoaded))
		} else if keyPath == Keys.status {
			//print(playerItem.status.rawValue)
			self.loadingFinished = true
			self.player?.play()
			self.isPlaying = true
		} else if keyPath == Keys.playbackBufferEmpty {
			// show loader
			self.loadingFinished = false
		} else if keyPath == Keys.playbackLikelyToKeepUp {
			// hide loader
			self.loadingFinished = true
		} else if keyPath == Keys.playbackBufferFull {
			// hide loader
			self.loadingFinished = true
		}
	}
	
	fileprivate func loadedTime() -> TimeInterval {
		guard let first = player?.currentItem?.loadedTimeRanges.first else { return 0.0 }
		let timeRange = first.timeRangeValue
		let startSeconds = CMTimeGetSeconds(timeRange.start)
		let durationSeconds = CMTimeGetSeconds(timeRange.duration)
		return startSeconds + durationSeconds
	}
	
	@objc func didFinishPlaying() {
		self.isPlaying = false
		//player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 50000))
		playingFinished = true
	}
	
	
	func stopPlaying() {
		player?.pause()
		removeTimeObserver()
		player = nil
	}
	
	deinit {
		player?.pause()
		removeTimeObserver()
		player = nil
		playerItem = nil
		print("deinit() called from the viewModel.")
	}
	
	// ================================================
	
	init(post: Post) {
		self.post = post
		super.init()
		guard let url = URL(string: post.videoURL) else { return }
		configurePlayerLayer(with: url)
		
		NotificationCenter.default.addObserver(self, selector: #selector(pauseIfPlaying), name: NSNotification.Name(rawValue: pauseVideoNotification), object: nil)
	}
	
	private var lines: [Line] = [] {
		didSet { linesChanged?(lines) }
	}
	
	var linesChanged: (([Line]) -> ())?
	
	private var linesToRemove: [Line] = [] {
		didSet { linesToRemoveChanged?(linesToRemove) }
	}
	
	var linesToRemoveCount: Int { return linesToRemove.count }
	
	var linesToRemoveChanged: (([Line]) -> ())?
	
	func cancelDeletionSelect() {
		linesToRemove.removeAll()
	}
	
	func fillLinesToRemove(from index: Int) {
		if let line = line(at: index) {
			self.linesToRemove.append(line)
			//printLinesToRemove()		// See if linesToRemove is correctly filled
		}
	}
	
	func removeFromLinesToRemove(at index: Int) {
		if let selectedLine = line(at: index) {
			linesToRemove = linesToRemove.filter { return $0.index != selectedLine.index }
			//printLinesToRemove()  // See if linesToRemove is correctly filled
		}
	}
	
	var numberOfSubtitles: Int {
		if let medium = medium {
			return medium.subtitles.count
		} else {
			return 0
		}
	}
	
	var numberOfLines: Int { return lines.count }
	
	private var currentLine: Line?
	var lastLine: Line? { return lines.last }
	
	private var currentSubtitle: Subtitle? {
		didSet {
			if let subtitle = currentSubtitle {
				subtitle.parse() // subtitle's parsedPayload and lines get filled
				showSubtitle(subtitle: subtitle)
				self.lines = subtitle.lines // fill lines for view model
				currentSubtitleChanged?(true, medium?.subtitles.count ?? 0, subtitle.lines.count)
			} else {
				currentSubtitleChanged?(false, 0, -1)
			}
		}
	}
	
	var subtitleValid: Bool { return self.currentSubtitle != nil }
	
	private var currentText: String = "" {
		didSet { currentTextChanged?(currentText) }
	}
	
	var currentTextChanged: ((String) -> ())?
	
	func observeSubtitles() {
		if let medium = medium, medium.subtitles.count > 0 {
			currentSubtitle = medium.subtitles[0]
		} else {
			currentSubtitle = nil
		}
	}
	
	var currentSubtitleChanged: ((Bool, Int, Int) -> ())?
	
	func line(at index: Int) -> Line? {
		guard index < lines.count else { return nil }
		return lines[index]
	}
	
	func viewModelForLine(at index: Int) -> SubtitleLineCellViewModel? {
		guard let line = line(at: index) else { return nil }
		return SubtitleLineCellViewModel(line: line)
	}
	
	func switchSubtitle() {
		guard let medium = medium else { return }
		guard medium.subtitles.count > 1 else { return }
		if let currentSubtitle = currentSubtitle {
			guard var currentIndex = medium.subtitles.firstIndex(of: currentSubtitle) else { return }
			if currentIndex == medium.subtitles.count - 1 {
				currentIndex = 0
			} else {
				currentIndex += 1
			}
			self.currentSubtitle = medium.subtitles[currentIndex]
		} else if medium.subtitles.count > 0 {
			currentSubtitle = medium.subtitles[0]
		}
	}
	
	var timeObserverToken: Any?
	
	func showSubtitle(subtitle: Subtitle?) {
		guard let subtitle = subtitle else { return }
		
		let payload = subtitle.parsedPayload
		removeTimeObserver()
		timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: .main, using: { [weak self] (time) in
			self?.currentText = Subtitles.searchSubtitles(payload, at: time.seconds)
		})
	}
	
	func removeTimeObserver() {
		if let token = self.timeObserverToken {
			player?.removeTimeObserver(token)
		}
	}
	
	func addNewLine(newLine: Line) {
		guard let file = currentSubtitle else { return }
		if file.addNewLineAndCommitChanges(with: newLine) {
			self.currentSubtitle = { self.currentSubtitle }()
			InfoView.show(message: InfoLiterals.addLineSuccess, success: true)
		} else {
			InfoView.show(message: InfoLiterals.addLineFail, success: false)
		}
	}
	
	func editLine(with editedLine: Line) {
		guard let file = self.currentSubtitle else { return }
		if file.editLineAndCommitChanges(with: editedLine) {
			self.currentSubtitle =  { self.currentSubtitle }()
			InfoView.show(message: InfoLiterals.editLineSuccess, success: true)
		} else {
			InfoView.show(message: InfoLiterals.editLineFail, success: false)
		}
	}
	
	func createSubtitleFile() {
		let path = nextAvailablePath()
		if FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
			let newFile = Subtitle(path: path)
			self.currentSubtitle = newFile
			InfoView.show(message: InfoLiterals.createFileSuccess, success: true)
			print("New file created: \(path)")
		} else {
			InfoView.show(message: InfoLiterals.createFileFail, success: true)
		}
		
	}
	
	fileprivate func nextAvailablePath() -> String {
		guard let medium = self.medium else { return "" }
		var surfixInt = medium.subtitles.count
		while true {
			let surfix = String(surfixInt)
			let path = (medium.path as NSString).deletingPathExtension + "_" + surfix + ".srt"
			if !FileManager.default.fileExists(atPath: path) {
				return path
			}
			surfixInt += 1
		}
	}
	
	func deleteSelectedLines() {
		
		guard self.linesToRemove.count > 0 else { return }
		guard let currentSubtitle = self.currentSubtitle else { return }
		
		let success = currentSubtitle.deleteLinesAndCommitChanges(with: self.linesToRemove)
		InfoView.show(message: success ? InfoLiterals.deleteLineSuccess : InfoLiterals.deleteLineFail, success: success)
		self.currentSubtitle = { self.currentSubtitle }()
		linesToRemove.removeAll()
	}
	
	func deleteCurrentSubtitle() {
		guard let medium = self.medium else { return }
		guard let currentSubtitle = self.currentSubtitle else { return }
		
		let success = currentSubtitle.delete()
		InfoView.show(message: success ? InfoLiterals.deleteFileSuccess : InfoLiterals.deleteFileFail, success: success)

		self.currentSubtitle = medium.subtitles.count > 0 ? medium.subtitles[0] : nil
		
	}
	
	// -----------------------------------------------------
	
//	func viewModelForInfoCell() -> InfoCellViewModel? {
//		guard let post = self.post else { return nil }
//		return InfoCellViewModel(post: post)
//	}
//
//	func viewModelForSubtitleSegmentCell() -> SubtitleSegmentCellViewModel? {
//		guard let post = self.post else { return nil }
//		return SubtitleSegmentCellViewModel(post: post)
//	}
//
//	func viewModelForCommentSegmentCell() -> CommentSegmentCellViewModel? {
//		guard let post = self.post else { return nil }
//		return CommentSegmentCellViewModel(post: post)
//	}
	
}
