//
//  FinishBlockHelper.swift
//  Lex
//
//  Created by nbcb on 2017/1/10.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit

/*
 ///无参无返回值
 typealias funcBlock = () -> () //或者 () -> Void
 
 ///有参数有返回值 返回值是String
 typealias funcBlockA = (String, String) -> String
 
 ///返回值是一个函数指针，入参为String
 typealias funcBlockB = (String, String) -> (String) -> ()
 
 ///返回值是一个函数指针，入参为String 返回值也是String
 typealias funcBlockC = (Int, Int) -> (String) -> String
 */

/// 有参数无返回值
typealias SaveUserImageBlock = (String) -> ()

//选择位置后返回位置Block
typealias ReturnLocationBlock = (Bool, AMapPOI) -> ()

