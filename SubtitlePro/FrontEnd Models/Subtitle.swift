//
//  Subtitle.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/1/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

class Subtitle: File, Equatable {
	
	override init(path: String) {
		super.init(path: path)
	}
	
	var lines = [Line]()
	
	static func ==(lhs: Subtitle, rhs: Subtitle) -> Bool {
		return lhs.path == rhs.path
	}
	
	let previewImg: UIImage? = UIImage(named: "file")
	var associatedMedium: Medium?

	var parsedPayload: [String: Any] = [String: Any]() {
		didSet {
			lines.removeAll()
			
			for index in parsedPayload.keys {
				guard var values = parsedPayload[index] as? [String: Any] else { continue }
				values["index"] = Int(index)
				let line = Line(dictionary: values)
				lines.append(line)
			}
			lines.sort { $0.index < $1.index }
		}
	}
	
	func parse() {
		
		let urlLocal = URL(fileURLWithPath: self.path)
		
		do {
			let content = try String(contentsOf: urlLocal, encoding: String.Encoding.utf8)
			parsedPayload = Subtitles.parseSubRip(content)
		} catch {
			do {
				guard let urlOnline = URL(string: self.path) else { return }
				let content = try String(contentsOf: urlOnline, encoding: String.Encoding.utf8)
				parsedPayload = Subtitles.parseSubRip(content)
			} catch {
				parsedPayload = [String: Any]()
			}
		}
	}
	
	func addNewLineAndCommitChanges(with newLine: Line) -> Bool {
		self.lines.append(newLine)
		return commitChangesToDisk()
	}
	
	func editLineAndCommitChanges(with line: Line) -> Bool {
		let indexInArray = line.index - 1
		self.lines[indexInArray] = line
		return commitChangesToDisk()
	}
	
	func deleteLinesAndCommitChanges(with lines: [Line]) -> Bool {
		remove(lines)
		fixIndex()
		return commitChangesToDisk()
	}
	
	func remove(_ lines: [Line]) {
		lines.forEach { (line) in
			self.lines = self.lines.filter { $0.index != line.index }
		}
	}
	
	func fixIndex() {
		for i in lines.indices { lines[i].index = i+1 }
	}
	
	func commitChangesToDisk() -> Bool {
		var content = ""
		for line in self.lines {
			content.append(line.str)
		}
		let url = URL(fileURLWithPath: self.path)
		print(content)
		do {
			try content.write(to: url, atomically: false, encoding: String.Encoding.utf8)
			return true
		} catch let err {
			print("*********  Failed to write to disk!!! ************")
			print(err)
			return false
		}
	}
	
	func isAssociated(with media: [Medium]) -> Bool {
		
		let prefix = (self.path as NSString).deletingPathExtension
		
		for medium in media {
			let mediumPrefix = (medium.path as NSString).deletingPathExtension
			if prefix.contains(mediumPrefix) {
				self.associatedMedium = medium
				return true
			}
		}
		return false
	}
}
