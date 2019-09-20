//
//  Line.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 11/10/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

struct Line: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(index)
	}
	
//	var hashValue: Int {
//		return index
//	}
	
	static func ==(lhs: Line, rhs: Line) -> Bool {
		return lhs.index == rhs.index && lhs.from == rhs.from && lhs.to == rhs.to && lhs.text == rhs.text
	}
	
	var index: Int
	var from: Time
	var to: Time
	var text: String
	
	init(dictionary: [String: Any]) {
		self.index = dictionary["index"] as? Int ?? 0
		self.from = (dictionary["from"] as? Double ?? 0).time()
		self.to = (dictionary["to"] as? Double ?? 0).time()
		self.text = dictionary["text"] as? String ?? ""
	}
	
	init(index: Int, from: Time, to: Time, text: String) {
		self.index = index
		self.from = from
		self.to = to
		self.text = text
	}
	
	var fromToTimeString: String {
		return self.from.timeString + " --> " + self.to.timeString
	}
	
	var str: String {
		return "\n" + String(self.index) + "\n" + self.from.timeString
						+ " --> " + self.to.timeString + "\n" + self.text + "\n"
	}
	
	var contentArray: [String] {
		get {
			return [String(from.hour), String(from.minute), String(from.second), String(from.millisecond),String(to.hour), String(to.minute), String(to.second), String(to.millisecond), text]
		}
	}
	
}





