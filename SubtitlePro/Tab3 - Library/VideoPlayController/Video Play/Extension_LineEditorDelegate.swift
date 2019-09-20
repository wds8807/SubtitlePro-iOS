//
//  Extension_LineEditorDelegate.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/14/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension VideoPlayController: LineEditorDelegate {
	
	func lineEditor(_ editor: LineEditor, tfHour: UITextField, tfMinute: UITextField, tfSecond: UITextField, tfMillSec: UITextField) {
		let currentPlayTime = viewModel.playerItem?.currentTime()
		guard let time = currentPlayTime?.time() else { return }
		
		tfHour.text = String(time.hour)
		tfMinute.text = String(time.minute)
		tfSecond.text = String(time.second)
		tfMillSec.text = String(time.millisecond)
		
		editor.editingChanged()
	}
	
	
	func lineEditor(_ editor: LineEditor, newLine: Line) {
		viewModel.addNewLine(newLine: newLine)
		didCancel(editor)
	}
	
	func lineEditor(_ editor: LineEditor, editedLine: Line) {
		viewModel.editLine(with: editedLine)
		didCancel(editor)
	}

	
	func didCancel(_ editor: LineEditor) {
		UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.lineEditor.frame.origin.y = self.view.frame.height
		}, completion: nil)
	}
	
}
