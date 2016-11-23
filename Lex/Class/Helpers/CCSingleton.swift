//
//  CCSingleton.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/18.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

/// 用户单例类
class CCSingleton: NSObject {
    
    /* 用户位置信息 */
    // 国家
    var country                     : String! 
    
    // 国家代码
    var countryCode                 : String! 
    
    // 省
    var state                       : String! 
    
    // 市
    var city                        : String! 
    
    // 区
    var subLocality                 : String! 
    
    // 街道地址
    var formattedAddressLines       : String! 
    
    // 具体位置
    var name                        : String! 
    
    // 去掉 "省"
    var state_Format                : String! 
    
    // 去掉 "市"
    var city_Format                 : String! 
    
    //MARK: - 单例 创建 CCSingleton
    class func sharedUser() -> CCSingleton {
        
        struct single {
            static var manager : CCSingleton? = CCSingleton()
        }
        return single.manager!
    }
}
