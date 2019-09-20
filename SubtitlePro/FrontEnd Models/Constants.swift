//
//  Enums.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/9/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import Foundation
//
//enum Status: String {
//	case noFileAssociated = "There's no subtitle file associated with this file yet. Create one from the menu.\n"
//	case noLine = "There's no line in this file yet. Create a line from the menu.\n"
//	case noVideo = "Import a video from the video library by tapping the top right."
//	case noSubtitle = "There's no subtitle file yet. Create one with one of the videos available."
//}

extension String {
	static let noFileAssociated = "该视频尚无字幕文件，请从菜单中创建"
	static let noLine = "该字幕文件尚无字幕条目，请从菜单中创建"
	static let noVideo = "媒体库尚无视频文件，点击右上角导入"
	static let noSubtitle = "尚无字幕文件，请从导入的视频中创建"
	
	static let hourValue = "\"hour\"必须大于等于0"
	static let minuteValue = "\"minute\"必须大于等于0，小于等于59"
	static let secondValue = "\"second\"必须大于等于0，小于等于59"
	static let msValue = "\"millisecond\"（毫秒）必须大于等于0，小于等于999"
	static let textInput = "字幕内容不能为空"
	static let fromGreaterThanTo = "\"From\"（起始时间）必须小于\"To\"（结束时间）"
	static let fromLessThanLastTo = "\"From\"（起始时间）必须大于上一行的\"To\"（结束时间）"
	static let unknownError = "未知错误"
}


//
//enum Warning: String {
//	case hourValue = "\"hour\" must have a value greater or equal to 0\n"
//	case minuteValue = "\"minute\" must have a value between 0 and 59, inclusive\n"
//	case secondValue = "\"second\" must have a value between 0 and 59, inclusive\n"
//	case msValue = "\"millisecond\" must have a value between 0 and 999, inclusive\n"
//	case textInput = "Subtitle text must not be empty\n"
//	case fromGreaterThanTo = "\"From\" should be less than \"To\"\n"
//	case fromLessThanLastTo = "\"From\" should be greater than the end time of last subtitle line\n"
//	case unknownError = "Unknow error"
//}




