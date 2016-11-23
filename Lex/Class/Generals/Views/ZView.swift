//
//  ZView.swift
//  Swift Demo
//
//  Created by nbcb on 16/4/5.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

protocol ZViewDelegate: NSObjectProtocol {
    func getZViewFrame(_ frame:CGRect);
}

class ZView: UIView {
    
    internal func newView(_ borderWidth: CGFloat, cornerRadius: CGFloat) -> ZView {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = borderWidth
        view.layer.borderWidth = cornerRadius
        view.layer.borderColor = UIColor.gray.cgColor
        return ZView()
    }
}
