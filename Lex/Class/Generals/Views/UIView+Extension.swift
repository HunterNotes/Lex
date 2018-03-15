//
//  UIView+Extension.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/30.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

extension UIView {
    
    /** 裁剪 view 的圆角
     * rect : frame
     * direction : 角落 左上、下角， 右上、下角，allCorners: 所有角
     * cornerRadius : 圆角幅度
     * cornerColor : 边框颜色
     * lineWidth : 边框宽度
     */
    
    func drawCorner(_ rect : CGRect, _ direction : UIRectCorner, _ cornerRadius : CGFloat, _ cornerColor : UIColor, _ lineWidth : CGFloat) {
        
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer();
        maskLayer.path = path.cgPath;
        maskLayer.fillColor = UIColor.clear.cgColor; //此处必须clear，因layer是直接添加在self.layer上的，若不为clear，title会被layer层的颜色所覆盖，若想设置button的颜色，可直接设置backGroundIame
        maskLayer.lineWidth = lineWidth;
        maskLayer.strokeColor = cornerColor.cgColor
        layer.mask = maskLayer
        self.layer.addSublayer(maskLayer);
    }
    
    /** 裁剪 view 的圆角
     * direction : 角落 左上、下角， 右上、下角，allCorners: 所有角
     * cornerRadius : 圆角幅度
     * cornerColor : 边框颜色
     * lineWidth : 边框宽度
     */
    
    func drawCorner(_ direction : UIRectCorner, _ cornerRadius : CGFloat, _ cornerColor : UIColor, _ lineWidth : CGFloat) {
        
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer();
        maskLayer.path = path.cgPath;
        maskLayer.fillColor = UIColor.clear.cgColor; //此处必须clear，因layer是直接添加在self.layer上的，若不为clear，title会被layer层的颜色所覆盖，若想设置button的颜色，可直接设置backGroundIame
        maskLayer.lineWidth = lineWidth;
        maskLayer.strokeColor = cornerColor.cgColor
        layer.mask = maskLayer
        self.layer.addSublayer(maskLayer);
    }
    
    
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }
}
