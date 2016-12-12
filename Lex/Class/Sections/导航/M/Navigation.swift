//
//  Navigation.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import Foundation

class Navigation: NSObject {
    
    var editable    : Bool?
    var id          : Int?
    var name        : String?
    
    init(dict: [String: AnyObject]) {
        
        id = dict["id"] as? Int
        name = dict["name"] as? String
        editable = dict["editable"] as? Bool
    }
}
