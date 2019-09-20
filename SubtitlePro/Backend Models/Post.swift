//
//  Post.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import UIKit

struct Post {
	
	let id: Int
	let uid: Int
	
	var user: User?
	var subtitles: [Subtitle] = []
	
	let videoURL: String
	let previewImageURL: String
	let title: String
	let description: String
	let duration: Double
	let creationDate: Date
	
	var likes = 0
	var dislikes = 0
	
	var comments = 0
	
	var didLike = false
	var didDislike = false
	

}
