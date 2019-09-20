//
//  InfoLiterals.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 8/3/18.
//  Copyright © 2018 Dongshuo Wu. All rights reserved.
//

import Foundation

struct InfoLiterals {
	// Hash value 0 - 7
	static let createFileSuccess = "新建字幕文件成功"
	static let addLineSuccess = "添加字幕条目成功"
	static let editLineSuccess = "字幕条目修改成功"
	static let deleteLineSuccess = "字幕条目删除成功"
	static let deleteFileSuccess = "字幕文件删除成功"
	static let deleteVideoSuccess = "视频及其所有字幕文件删除成功"
	static let importSuccess = "视频导入成功"
	static let uploadSuccess = "上传成功"
	// Hash value > 7
	static let importFail = "视频导入失败：文件已经存在"
	static let createFileFail = "创建字幕文件失败"
	static let addLineFail = "添加字幕条目添加失败"
	static let addEditLineFileNotExist = "当前视频尚无字幕文件：请先创建字幕文件"
	static let editLineFail = "提交修改失败"
	static let lineNotExist = "当前文件尚无字幕条目"
	static let editOrDeleteLineFileNotExist = "当前视频尚无字幕文件"
	static let deleteLineFailInvalidSubtitlePath = "无法删除文件：文件位置无效"
	static let deleteLineFail = "无法删除字幕条目"
	static let fileDoesntExist = "不存在字幕文件"
	static let deleteVideoFail = "一个或多个文件删除失败"
	static let deleteFileFail = "删除文件失败"
	static let uploadFail = "上传失败"
	static let followFail = "关注失败"
}
