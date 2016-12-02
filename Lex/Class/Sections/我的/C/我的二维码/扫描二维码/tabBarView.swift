//
//  tabBarView.swift
//  Lex
//
//  Created by nbcb on 2016/12/2.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class tabBarView: UIView {

    var weakSelf : tabBarView {
        
        weak var _weakSelf : tabBarView? = self
        return _weakSelf!
    }

    //相册
    weak var photo : UIButton? {
    
        let button : UIButton = UIButton.init(type: .custom)
        
        return button
    }

    //相机
    weak var camera : UIButton? {
        
        let button : UIButton = UIButton.init(type: .custom)
        
        
        return button
    }
    
    //我的二维码
    weak var myQRCode : UIButton? {
        
        let button : UIButton = UIButton.init(type: .custom)
        
        
        return button
    }

}
