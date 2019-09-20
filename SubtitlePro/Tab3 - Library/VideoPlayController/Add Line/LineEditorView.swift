//
//  LineEditorController.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/9/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

protocol LineEditorDelegate: NSObjectProtocol {
	func lineEditor(_ editor: LineEditor, newLine: Line)
	func lineEditor(_ editor: LineEditor, editedLine: Line)
	func didCancel(_ editor: LineEditor)
	
	func lineEditor(_ editor: LineEditor, tfHour: UITextField, tfMinute: UITextField, tfSecond: UITextField, tfMillSec: UITextField)

}

class LineEditor: UIView {
	
	enum Mode {
		case addLine, editLine
	}
	
	var mode: Mode = .addLine
	
	var edited = false
	
	weak var delegate: LineEditorDelegate?
	
	var viewModel: LineEditorViewModel! {
		didSet {
			viewModel.warningChanged = { [unowned self] (totalWarning) in
				self.warningLabel.text = totalWarning
			}
			
			viewModel.updateTextFieldsAndHintLabel = { [unowned self] (hintString) in
				self.hintLabel.text = hintString
			}
		}
	}
	
	func label(text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = .gray240
		label.textAlignment = .justified
		label.font = .boldSystemFont(ofSize: 15.dynamicSize())
		return label
	}
	
	func timeLabel(text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.textColor = .gray240
		label.textAlignment = .center
		label.font = .boldSystemFont(ofSize: 15.dynamicSize())
		return label
	}
	
	func textField() -> UITextField {
		let tf = UITextField()
		tf.backgroundColor = .gray40
		tf.borderStyle = .roundedRect
		tf.tintColor = .gray240
		tf.keyboardType = .numberPad
		tf.textColor = .gray240
		tf.textAlignment = .center
		tf.delegate = self
		tf.keyboardAppearance = .dark
		tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
		return tf
	}
	
	func textView() -> UITextView {
		let tv = UITextView()
		tv.backgroundColor = .gray40
		tv.textColor = .gray240
		tv.tintColor = .gray240
		tv.font = .boldSystemFont(ofSize: 16.dynamicSize())
		tv.layer.borderWidth = 0.5
		tv.layer.borderColor = UIColor.clear.cgColor
		tv.layer.cornerRadius = 5
		tv.keyboardAppearance = .dark
		tv.delegate = self
		return tv
	}
	
	lazy var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.delegate = self
		scroll.alwaysBounceVertical = true
		scroll.backgroundColor = .gray64
		scroll.keyboardDismissMode = .onDrag
		scroll.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
		return scroll
	}()
	
	let containerView = UIView()
	
	let hintLabel: UILabel = {
		let label = UILabel()
		label.configure(fontSize: 14.dynamicSize(), bold: false, textColor: .gray240, lineCount: 0, alignment: .justified)
		label.sizeToFit()
		label.lineBreakMode = .byWordWrapping
		label.setContentHuggingPriority(.defaultHigh, for: .vertical)
		return label
	}()
	
	lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.configure(title: "取消", color: .white, bgColor: .themeRed, image: nil, cornerRadius: 5)
		button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
		button.titleLabel?.font = .systemFont(ofSize: 15.dynamicSize())
		return button
	}()
	
	
	lazy var submitButton: UIButton = {
		let button = UIButton()
		button.configure(title: "提交", color: .white, bgColor: .themeGreen, image: nil, cornerRadius: 5)
		button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		button.setEnabled(false)
		button.titleLabel?.font = .systemFont(ofSize: 15.dynamicSize())
		return button
	}()
	
	lazy var autoFillFromButton: UIButton = {
		let button = UIButton()
		button.configure(title: "填入当前\n播放时刻", color: .white, bgColor: .gray40, image: nil, cornerRadius: 5)
		button.addTarget(self, action: #selector(autoFillFromTime), for: .touchUpInside)
		button.titleLabel?.font = .systemFont(ofSize: 11.dynamicSize())
		button.titleLabel?.numberOfLines = 0
		return button
	}()
	
	@objc func autoFillFromTime() {
		delegate?.lineEditor(self, tfHour: fromHourTF, tfMinute: fromMinuteTF, tfSecond: fromSecondTF, tfMillSec: fromMilliSecTF)
	}
	
	lazy var autoFillToButton: UIButton = {
		let button = UIButton()
		button.configure(title: "填入当前\n播放时刻", color: .white, bgColor: .gray40, image: nil, cornerRadius: 5)
		button.addTarget(self, action: #selector(autoFillToTime), for: .touchUpInside)
		button.titleLabel?.font = .systemFont(ofSize: 11.dynamicSize())
		print(self.frame.width, UIScreen.main.bounds.height)
		button.titleLabel?.numberOfLines = 0
		return button
	}()
	
	@objc func autoFillToTime() {
		delegate?.lineEditor(self, tfHour: toHourTF, tfMinute: toMinuteTF, tfSecond: toSecondTF, tfMillSec: toMilliSecTF)
	}
	
	
	let buttonContainer = UIView()

	let topLeftSpace = UILabel()
	
	lazy var fromLabel = label(text: "  开始:")
	lazy var toLabel = label(text: "  结束:")
	lazy var hourlabel = timeLabel(text: "hour")
	lazy var minuteLabel = timeLabel(text: "minute")
	lazy var secondLabel = timeLabel(text: "second")
	lazy var milliSecLabel = timeLabel(text: "millsec")
	lazy var textLabel = label(text: "  字幕文本:")
	lazy var warningLabel = label(text: "")
	
	lazy var fromHourTF = textField()
	lazy var fromMinuteTF = textField()
	lazy var fromSecondTF = textField()
	lazy var fromMilliSecTF = textField()
	lazy var toHourTF = textField()
	lazy var toMinuteTF = textField()
	lazy var toSecondTF = textField()
	lazy var toMilliSecTF = textField()
	
	lazy var contentTV = self.textView()
	
	lazy var textFields = [fromHourTF, fromMinuteTF, fromSecondTF, fromMilliSecTF, toHourTF, toMinuteTF, toSecondTF, toMilliSecTF]
	
	@objc func handleSubmit() {
		guard let line = viewModel.line else { return }
		if mode == .addLine {
			delegate?.lineEditor(self, newLine: line)
		} else if mode == .editLine {
			delegate?.lineEditor(self, editedLine: line)
		}
	}
	
	@objc func handleCancel() {
		delegate?.didCancel(self)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(scrollView)
		scrollView.frame = self.bounds
		
		scrollView.addSubview(containerView)
		containerView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: self.frame.height)
		
		containerView.addSubview(hintLabel)
		hintLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0+5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
		
		let topRightSpace = UIView()
		let topStackView = UIStackView(arrangedSubviews: [topLeftSpace, hourlabel, minuteLabel, secondLabel, milliSecLabel, topRightSpace])
		topStackView.configure(axis: .horizontal, distribution: .fillEqually, spacing: 8)
		
		let fromStackView = UIStackView(arrangedSubviews: [fromLabel, fromHourTF, fromMinuteTF, fromSecondTF, fromMilliSecTF, autoFillFromButton])
		fromStackView.configure(axis: .horizontal, distribution: .fillEqually, spacing: 5)
		
		let toStackView = UIStackView(arrangedSubviews: [toLabel, toHourTF, toMinuteTF, toSecondTF, toMilliSecTF, autoFillToButton])
		toStackView.configure(axis: .horizontal, distribution: .fillEqually, spacing: 5)
		
		containerView.addSubview(topStackView)
		topStackView.anchor(top: hintLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30.dynamicHeight())
		
		containerView.addSubview(fromStackView)
		fromStackView.anchor(top: topStackView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35.dynamicHeight())
		
		containerView.addSubview(toStackView)
		toStackView.anchor(top: autoFillFromButton.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35.dynamicHeight())
		
		let buttonStack = UIStackView(arrangedSubviews: [cancelButton, submitButton])
		buttonStack.configure(axis: .horizontal, distribution: .fillEqually, spacing: 8)
		
		containerView.addSubview(buttonStack)
		buttonStack.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 0, height: 40)
		
		containerView.addSubview(textLabel)
		textLabel.anchor(top: autoFillToButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35.dynamicHeight())
		
		containerView.addSubview(contentTV)
		contentTV.anchor(top: textLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 75)
		
		containerView.addSubview(warningLabel)
		
		warningLabel.anchor(top: contentTV.bottomAnchor, left: leftAnchor, bottom: buttonStack.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
		warningLabel.textColor = .themeRed
		warningLabel.sizeToFit()
		warningLabel.numberOfLines = 0
	}
	
	func fillBlanks() {
		
		guard let line = viewModel.line else {
			textFields.forEach { $0.text = "" }
			contentTV.text = ""
			return
		}
		
		for i in 0...7 {
			textFields[i].text = line.contentArray[i]
		}
		
		contentTV.text = line.contentArray[8]
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension LineEditor: UITextFieldDelegate, UITextViewDelegate {
	
	@objc func editingChanged() {
		guard let fh = fromHourTF.text else { return }
		guard let fm = fromMinuteTF.text else { return }
		guard let fs = fromSecondTF.text else { return }
		guard let fms = fromMilliSecTF.text else { return }
		guard let toh = toHourTF.text else { return }
		guard let tom = toMinuteTF.text else { return }
		guard let tos = toSecondTF.text else { return }
		guard let toms = toMilliSecTF.text else { return }
		
		guard let text = contentTV.text else { return }
		
		guard let _ = viewModel.line(fh: fh, fm: fm, fs: fs, fms: fms, toh: toh, tom: tom, tos: tos, toms: toms, text: text) else {
			submitButton.setEnabled(false)
			return }
		
		submitButton.setEnabled(true)
	}
	
	@objc func textViewDidChange(_ textView: UITextView) {
		editingChanged()
	}
}
