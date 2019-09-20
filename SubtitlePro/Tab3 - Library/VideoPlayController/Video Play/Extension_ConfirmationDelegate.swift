//
//  Extension_confirmationDelegate.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/17/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

extension VideoPlayController: ConfirmationDelegate {
	
	func confirmation(_ confirmation: Confirmation, action: ActionToConfirm) {
		
		if action == .deleteFile {
			viewModel.deleteCurrentSubtitle()
		}
		
		func removeAllCellSelection() {

			subtitleCollectionView.indexPathsForSelectedItems?.forEach { (indexPath) in
				if let cell = subtitleCollectionView.cellForItem(at: indexPath) as? SubtitleLineCell {
					cell.isSelected = false
					cell.removeSelectedView()
				} else {
					subtitleCollectionView.reloadItems(at: [indexPath])
				}
			}
		}
		
		if action == .deleteLine {
			removeAllCellSelection()
			viewModel.deleteSelectedLines()
		}
	}
	
	
}
