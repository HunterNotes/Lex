//
//  SaveUserImageHelper.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/15.
//  Copyright © 2016年 周清城. All rights reserved.
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

var saveImageBlock : SaveUserImageBlock?

class SaveUserImageHelper: NSObject {
    
    /*这写法就可以初始时为nil了,因为生命周其中，(理想状态)可能为nil所以用?
     这写法也可以初始时为nil了,因为生命周其中，(理想状态)认为不可能为nil,所以用!
     */
    var saveImgBlock : SaveUserImageBlock?
    func saveImage(_ block : @escaping SaveUserImageBlock, msg : String) {
        
        saveImgBlock = block
        if ((saveImgBlock) != nil) {
            saveImgBlock!(msg)
        }
    }
}
