//
//  Extension_MenuDelegate.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/8/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

extension VideoPlayController: MenuDelegate {
	
	func menu(_ menu: Menu, didSelect item: String) {
		
		switch item {
		case MenuItem.createFile: createSubtitleFile(); break
		case MenuItem.addLine: addLine(); break
		case MenuItem.editLine: editLine(); break
		case MenuItem.deleteLine: deleteLines(); break
		case MenuItem.deleteFile: deleteSubtitleFile(); break
		//case MenuItem.signIn: break
		default: break
		}
	}
	
	func menu(_ menu: Menu, didTapBlackView blackView: UIView) {
		menu.handleDismiss2()
	}
	
	func createSubtitleFile() {
		viewModel.createSubtitleFile()
	}
	
	func addLine() {
		
		if !viewModel.subtitleValid {
			InfoView.show(message: InfoLiterals.addEditLineFileNotExist, success: false)
			return
		}
		
		viewModel.pauseIfPlaying()
		
		mode = .addLine
		
		lineEditor.viewModel.mode = .addLine
		lineEditor.viewModel.lastLine = self.viewModel.lastLine
		lineEditor.viewModel.line = nil
		lineEditor.fillBlanks()
		
		showLineEditor()
	}
	
	func showLineEditor() {
		let deltaY: CGFloat = isIphoneX() ? 44 : 0
		let y = view.frame.width * 9 / 16 + deltaY
		
		UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.lineEditor.frame.origin.y = y
		}, completion: nil)
	}
	
	func editLine() {
		if lineEditValidityCheck() { mode = .editLine }
	}
	
	fileprivate func lineEditValidityCheck() -> Bool {
		
		if viewModel.subtitleValid {
			if viewModel.numberOfLines == 0 {
				InfoView.show(message: InfoLiterals.lineNotExist, success: false)
				return false
			} else {
				return true
			}
		} else {
			InfoView.show(message: InfoLiterals.editOrDeleteLineFileNotExist, success: false)
			return false
		}
	}
	
	func deleteLines() {
		if lineEditValidityCheck() { mode = .deleteLines }
	}
	
	func deleteSubtitleFile() {
		
		if !viewModel.subtitleValid {
			InfoView.show(message: InfoLiterals.editOrDeleteLineFileNotExist, success: false)
			return
		}
		confirmation.show(with: .deleteFile)
	}
}
