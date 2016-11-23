//
//  ZCanvasView.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/16.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class ZCanvasView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let pathRect = self.bounds.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 10)
        path.lineWidth = 2
        UIColor.clear.setFill()
        UIColor.white.setStroke()
        path.fill()
        path.stroke()
    }
}
