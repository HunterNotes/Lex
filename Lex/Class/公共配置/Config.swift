//
//  Config.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/31.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

//MARK: -------------------------- 枚举 --------------------------
enum TopicType: Int {
    /// 精选
    case selection = 4
    /// 美食
    case food = 14
    /// 家居
    case household = 16
    /// 数码
    case digital = 17
    /// 美物
    case goodThing = 13
    /// 杂货
    case grocery = 22
}

enum ShareButtonType: Int {
    /// 微信朋友圈
    case weChatTimeline = 0
    /// 微信好友
    case weChatSession = 1
    /// 微博
    case weibo = 2
    /// QQ 空间
    case qZone = 3
    /// QQ 好友
    case qqFriends = 4
    /// 复制链接
    case copyLink = 5
}

enum OtherLoginButtonType: Int {
    /// 微博
    case weiboLogin = 100
    /// 微信
    case weChatLogin = 101
    /// QQ
    case qqLogin = 102
}

//MARK: -------------------------- app启动/登录 --------------------------
/**
 * 是否第一次启动
 */
let FirstLaunch : String = "FirstLaunch"

/**
 * 是否登录
 */
let isLogin = "isLogin"

/**
 * 用户引导页倒计时总进度
 */
let LAUNCHPROGRESS : Double = 90.0

/**
 * 用户引导页倒计时
 */
var LAUNCHCOUNTDOWN : Double = 3.0

//MARK: -------------------------- 尺寸 --------------------------
/**
 * 宽
 */
let app_width: CGFloat = UIScreen.main.bounds.size.width

/**
 * 高
 */
let app_height: CGFloat = UIScreen.main.bounds.size.height

/**
 * tableView 基础高度
 */
let tableView_height: CGFloat = UIScreen.main.bounds.size.height - 44 - 20 - 49

/**
 * tableView 基础frame
 */
let tableView_frame: CGRect = CGRect(x: 0, y: 44 + 20, width: app_width, height: tableView_height)
/**
 * 间距
 */
let kMargin: CGFloat = 10.0

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
 * 分享按钮背景高度
 */
let kTopViewH: CGFloat = 230

//MARK: -------------------------- 数据库/图片存储 --------------------------
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

//MARK: -------------------------- 二维码相关 --------------------------
/**
 * 二维码内容
 */
var QRTEXT : String = "https://github.com/HunterNotes/Swift_Debug"

/**
 * 二维码尺寸
 */
let ScanCode_Height : CGFloat = app_height / 3

/**
 * 二维码↔️间距
 */
let ScanCode_Space : CGFloat = (app_width - (app_height / 3)) / 2

//MARK: -------------------------- 网络请求相关 --------------------------
/**
 * 服务器地址
 */
let BASE_URL = "http://api.dantangapp.com/"

/**
 * code 码 200 操作成功
 */
let RETURN_OK = 200

/**
 * 动画时长
 */
let kAnimationDuration = 0.25

//MARK: -------------------------- 颜色 --------------------------
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

/**
 * 进入主界面
 */
func enterMainInterface() {
    UIApplication.shared.keyWindow?.rootViewController = ZTabBarController()
}
