//
//  Extension_Date.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/25/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

extension Date {
	
	func timeAgoPublicChn() -> String {
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		let month = 30 * day
		let year = 365 * day
		
		let quotient: Int
		let unit: String
		if secondsAgo < 20 {
			return "刚刚"
		} else if secondsAgo < minute {
			quotient = secondsAgo
			unit = "秒前"
		} else if secondsAgo < hour {
			quotient = secondsAgo / minute
			unit = "分钟前"
		} else if secondsAgo < day {
			quotient = secondsAgo / hour
			unit = "小时前"
		} else if secondsAgo < week {
			quotient = secondsAgo / day
			unit = "天前"
		} else if secondsAgo < month {
			quotient = secondsAgo / week
			unit = "星期前"
		} else if secondsAgo < year{
			quotient = secondsAgo / month
			unit = "个月前"
		} else {
			quotient = secondsAgo / year
			unit = "年前"
		}
		return "\(quotient)\(unit)"
	}
	
	func timeAgoPublic() -> String {
		
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		let month = 30 * day
		let year = 365 * day
		
		let quotient: Int
		let unit: String
		if secondsAgo < 60 {
			return "Just now"
		} else if secondsAgo < minute {
			quotient = secondsAgo
			unit = "second"
		} else if secondsAgo < hour {
			quotient = secondsAgo / minute
			unit = "min"
		} else if secondsAgo < day {
			quotient = secondsAgo / hour
			unit = "hour"
		} else if secondsAgo < week {
			quotient = secondsAgo / day
			unit = "day"
		} else if secondsAgo < month {
			quotient = secondsAgo / week
			unit = "week"
		} else if secondsAgo < year{
			quotient = secondsAgo / month
			unit = "month"
		} else {
			quotient = secondsAgo / year
			unit = "year"
		}
		return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
	}
	
	func timeAgoChn() -> String {
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		
		let quotient: Int
		let unit: String
		if secondsAgo < 60 {
			return "刚刚"
		} else if secondsAgo < minute {
			quotient = secondsAgo
			unit = "秒前"
		} else if secondsAgo < hour {
			quotient = secondsAgo / minute
			unit = "分钟前"
		} else if secondsAgo < day {
			quotient = secondsAgo / hour
			unit = "小时前"
		} else if secondsAgo < week {
			quotient = secondsAgo / day
			unit = "天前"
		} else {
			let calendar = Calendar.current
			let year = calendar.component(.year, from: self)
			let month = calendar.component(.month, from: self)
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "zh_CN")
			let monthName = dateFormatter.shortMonthSymbols[month-1]
			let day = calendar.component(.day, from: self)
			return "\(year)年\(monthName)\(day)日"
		}
		return "\(quotient)\(unit)"
	}
	
	func timeAgo() -> String {
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		
		let quotient: Int
		let unit: String
		if secondsAgo < 60 {
			return "Just now"
		} else if secondsAgo < minute {
			quotient = secondsAgo
			unit = "second"
		} else if secondsAgo < hour {
			quotient = secondsAgo / minute
			unit = "min"
		} else if secondsAgo < day {
			quotient = secondsAgo / hour
			unit = "hour"
		} else if secondsAgo < week {
			quotient = secondsAgo / day
			unit = "day"
		} else {
			let calendar = Calendar.current
			let year = calendar.component(.year, from: self)
			let month = calendar.component(.month, from: self)
			let monthName = DateFormatter().shortMonthSymbols[month-1]
			let day = calendar.component(.day, from: self)
			return "\(monthName) \(day), \(year)"
		}
		return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
	}
}


