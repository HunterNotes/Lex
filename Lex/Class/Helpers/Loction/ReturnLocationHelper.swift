//
//  ReturnLocationHelper.swift
//  Lex
//
//  Created by nbcb on 2017/1/10.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit


class ReturnLocationHelper: NSObject {
    
    var locationBlock : ReturnLocationBlock?
    
    //MARK: 单列
    class func sharedManager() -> ReturnLocationHelper {
        struct single {
            static var manager : ReturnLocationHelper? = ReturnLocationHelper()
        }
        return single.manager!
    }
    
    func returnLocation(_ block : @escaping ReturnLocationBlock, _ finish : Bool, _ mapPOI : AMapPOI) {
        
        locationBlock = block
        if ((locationBlock) != nil) {
            locationBlock!(finish, mapPOI)
        }
    }
}
