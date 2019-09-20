//
//  ProfileContentCellViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 7/18/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct ProfileContentCellViewModel {
	
	let menuItem: ProfileMenuItem
	
	var labelText: String { return menuItem.rawValue }
	
	var textColor: UIColor {
		switch menuItem {
		case .login: return .themeGreen
		case .signOut: return .themeRed
		default: return .gray32
		}
	}
}

enum ProfileMenuItem: String {
	
	case posts = "Uploads"
	case followers = "Followers"
	case following = "Following"
	case editProfile = "Edit Profile"
	case signOut = "Sign out"
	case login = "Log in"
}
