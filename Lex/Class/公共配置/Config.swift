//
//  Config.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/31.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import Foundation
import UIKit


/**
 * 宽
 */
let app_width: CGFloat = UIScreen.main.bounds.size.width

/**
 * 高
 */
let app_height: CGFloat = UIScreen.main.bounds.size.height

/**
 * 本地数据库，用户信息表名称
 */
let TABLENAME : String = "USER"

/**
 * 用户名称
 */
var USERNAME : String! = ""

/**
 * 数据库表->主键
 */
let USER_ID : String = "userID"

/**
 * 数据库表->用户名称
 */
let USER_NAME : String = "userName"

/**
 * 数据库表->用户头像名称
 */
let USER_IMGNAME : String = "userImage"

/**
 * 数据库表->用户二维码图片名称
 */
let USER_QRIMGNAME : String = "qrImage"

/**
 * 存储图片时，根据格式拼接数据头 添加header信息，扩展名信息
 */
let BASE64HEADER : String = "data:image/png;base64,"

/**
 * 二维码内容
 */

var QRTEXT : String = "https://github.com/HunterNotes/Swift_Debug"

/**
 * tableView 基础高度
 */
let tableView_height: CGFloat = UIScreen.main.bounds.size.height - 44 - 20 - 49

/**
 * tableView 基础frame
 */
let tableView_frame: CGRect = CGRect(x: 0, y: 44 + 20, width: app_width, height: tableView_height)

/**
 * 顶部标题的高度
 */
let kTitlesViewH: CGFloat = 35

/**
 * 顶部标题的y
 */
let kTitlesViewY: CGFloat = 64

/**
 * 线宽
 */
let klineWidth: CGFloat = 1.0

/**
 * 首页顶部标签指示条的高度
 */
let kIndicatorViewH: CGFloat = 2.0

/**
 * 配色
 */
func RGBA (_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/**
 * 基础颜色
 */
func base_color() -> UIColor {
    return RGBA(225, g: 236, b: 244, a: 0.85)
}
/**
 * 导航条颜色
 */
func nav_color() -> UIColor {
    return RGBA(2, g: 2, b: 2, a: 0.8)
}
/**
 * 背景灰色
 */
func globalBGColor() -> UIColor {
    return RGBA(240, g: 240, b: 240, a: 1)
}

/**
 * 红色
 */
func globalRedColor() -> UIColor {
    return RGBA(245, g: 80, b: 83, a: 1.0)
}

