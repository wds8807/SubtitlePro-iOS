//
//  LineEditorViewModel.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/9/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation
import UIKit

enum Mode: String {
	case none = "none"
	case addLine = "添加一行字幕"
	case editLine = "编辑"
	case deleteLines = "选择并删除"
}

class LineEditorViewModel {
	
	var mode: Mode?
	
	var warningChanged: ((String) -> ())?
	
	var totalWarning: String { return hourWarning + minuteWarning + secondWarning + millSecWarning + fromToTime + contentWarning }
	
	private var hourWarning: String = "" {
		didSet {
			warningChanged?(totalWarning) }
	}
	
	private var minuteWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	private var secondWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	private var millSecWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	private var fromToTime: String = "" {
		didSet { warningChanged?(totalWarning) }
	}
	
	private var contentWarning: String = "" {
		didSet { warningChanged?(totalWarning) }
	}

	
	struct Warning {
		
		static let hour = "hour（小时）必须介于0-59之间\n"
		static let minute = "minute（分钟）必须介于0-59之间\n"
		static let second = "second（秒）必须介于0-59之间\n"
		static let millSec = "millSec（毫秒）必须介于0-999之间\n"
		static let time = "结束时刻不能早于起始时刻\n"
		static let content = "内容不能为空\n"
	}
	
	var updateTextFieldsAndHintLabel: ((String) -> ())?
	
	// problem from last night, to be fixed:
	// fill blank should not be called every time line gets set.
	var line: Line? {
		didSet {
			
			var hintString = ""
			if self.mode == .addLine {
				hintString = "  正在编辑第\(self.currentIndex)条字幕，这是一条新添加的条目"
			} else if self.mode == .editLine {
				hintString = "  正在编辑第\(self.currentIndex)条字幕，它将覆盖现有的这一条目"
			}
			updateTextFieldsAndHintLabel?(hintString)
		}
	}
	
	
	
	var lastLine: Line?
	var currentIndex: Int {
		get {
			
			if let line = line {
				return line.index
			}
			else if let lastLine = lastLine {
				return lastLine.index + 1
			} else {
				return 1
			}
		}
	}
	
	var warnings = [Warning]()
	
	fileprivate func clearWarnings() {
		hourWarning = ""; minuteWarning = ""; secondWarning = ""; millSecWarning = ""; contentWarning = ""; fromToTime = ""
	}
	
	func line(fh: String, fm: String, fs: String, fms: String, toh: String, tom: String, tos: String, toms: String, text: String) -> Line? {
		clearWarnings()
		var fromDict = [String: Any]()
		var toDict = [String: Any]()
		var lineDict = [String: Any]()
		// from
		if let fh = Int(fh), fh >= 0, fh <= 59 {
			fromDict["hour"] = fh
		} else {
			hourWarning = Warning.hour
		}
		
		if let fm = Int(fm), fm >= 0, fm <= 59 {
			fromDict["minute"] = fm
		} else {
			minuteWarning = Warning.minute
		}
		
		if let fs = Int(fs), fs >= 0, fs <= 59 {
			fromDict["second"] = fs
		} else {
			secondWarning = Warning.second
		}
		
		if let fms = Int(fms), fms >= 0, fms <= 999 {
			fromDict["millisecond"] = fms
		} else {
			millSecWarning = Warning.millSec
		}
		// to
		if let toh = Int(toh), toh >= 0, toh <= 59 {
			toDict["hour"] = toh
		} else {
			hourWarning = Warning.hour
		}
		
		if let tom = Int(tom), tom >= 0, tom <= 59 {
			toDict["minute"] = tom
		} else {
			minuteWarning = Warning.minute
		}
		
		if let tos = Int(tos), tos >= 0, tos <= 59 {
			toDict["second"] = tos
		} else {
			secondWarning = Warning.second
		}
		
		if let toms = Int(toms), toms >= 0, toms <= 999 {
			toDict["millisecond"] = toms
		} else {
			millSecWarning = Warning.millSec
		}
		
		guard totalWarning.isEmpty else { return nil }
		
		let from = Time(dictionary: fromDict)
		let to = Time(dictionary: toDict)
		
		guard from <= to else {
			fromToTime = Warning.time
			return nil
		}
		
		let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
		
		if !text.isEmpty {
			lineDict["text"] = text
		} else {
			contentWarning = Warning.content
		}
		guard totalWarning.isEmpty else { return nil }
		
		let line = Line(index: currentIndex, from: from, to: to, text: text)
		self.line = line
		return line
	}
	
	
	
}
