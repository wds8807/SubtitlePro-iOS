//
//  Time.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/14/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import Foundation

struct Time {
	var hour: Int
	var minute: Int
	var second: Int
	var millisecond: Int
	
	init(dictionary: [String: Any]) {
		self.hour = dictionary["hour"] as? Int ?? 0
		self.minute = dictionary["minute"] as? Int ?? 0
		self.second = dictionary["second"] as? Int ?? 0
		self.millisecond = dictionary["millisecond"] as? Int ?? 0
	}
	
	init(doubleValue: Double) {
		self.hour = doubleValue.time().hour
		self.minute = doubleValue.time().minute
		self.second = doubleValue.time().second
		self.millisecond = doubleValue.time().millisecond
	}
	
	init() {
		self.hour = 0
		self.minute = 0
		self.second = 0
		self.millisecond = 0
	}
	
	func doubleValue() -> Double {
		let h = Double(self.hour)
		let m = Double(self.minute)
		let s = Double(self.second)
		let c = Double(self.millisecond)
		let returnValue = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
		return returnValue
	}
	
	static func <(lhs: Time, rhs: Time) -> Bool {
		return lhs.doubleValue() < rhs.doubleValue()
	}
	
	static func <=(lhs: Time, rhs: Time) -> Bool {
		return lhs.doubleValue() <= rhs.doubleValue()
	}
	
	static func >(lhs: Time, rhs: Time) -> Bool {
		return lhs.doubleValue() > rhs.doubleValue()
	}
	
	static func >=(lhs: Time, rhs: Time) -> Bool {
		return lhs.doubleValue() >= rhs.doubleValue()
	}
	
	static func ==(lhs: Time, rhs: Time) -> Bool {
		return lhs.doubleValue() == rhs.doubleValue()
	}
	
	var timeString: String {
		return String(format: "%02d", self.hour) + ":" + String(format: "%02d", self.minute) + ":" + String(format: "%02d", self.second) + "," + String(format: "%03d", self.millisecond)
	}
}

extension Double {
	
	func time() -> Time {
		let doubleValue = self
		let ms = doubleValue * 1000
		let milliseconds = Int(ms.rounded())
		let millSecValue = milliseconds % 1000
		let seconds = milliseconds / 1000
		let secondValue = seconds % 60
		let minutes = seconds / 60
		let minuteValue = minutes % 60
		let hours = minutes / 60
		let hourValue = hours % 60
		let values = ["hour": hourValue, "minute": minuteValue, "second": secondValue, "millisecond": millSecValue]
		return Time(dictionary: values)
	}
	
	var durationStr: String {
		let secondsDouble = self
		let seconds = Int(secondsDouble.rounded())
		let secondValue = seconds % 60
		let minutes = seconds / 60
		let minuteValue = minutes % 60
		let secondsString = String(format: "%02d", secondValue)
		let minutesString = String(format: minuteValue < 10 ? "%01d" : "%02d", minuteValue)
		return "\(minutesString):\(secondsString)"
	}
}

