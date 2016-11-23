//
//  ZButton.swift
//  Swift Demo
//
//  Created by nbcb on 16/3/18.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit
import Foundation

enum selectedButtonType : Int {
    
    case first = 1, second, three, four
}

@IBDesignable open class ZButton: UIButton {

 var selectedType : selectedButtonType = .first
    
    var button: ZButton!
    
    open func newButton(_ frame: CGRect) -> ZButton {
        var btn : ZButton
        
            btn = ZButton.init(frame: frame)
            btn.setTitle("点击按钮", for: UIControlState())
            btn.setTitle("未点击", for: UIControlState.highlighted)
            btn.backgroundColor = UIColor.black
        btn.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
        return btn
    }
    
    func clickEvent (_ sender: UIButton) {
        
    }
}
