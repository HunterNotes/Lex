//
//  UIImage+QRCode.swift
//  Swift_Demo
//
//  Created by cc on 2016/11/18.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    //MARK: - 识别图片二维码
    func recognizeQRCode() -> String? {
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: self.cgImage!))
        guard (features?.count)! > 0
            else {
                return nil
        }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
    }
    
    //MARK: - 获取圆角图片(不带边框)
    func getRoundRectImage(_ size : CGFloat, _ radius : CGFloat) -> UIImage {
        
        return getRoundRectImage(size, radius, nil, nil)
    }
    
    //MARK: - 获取圆角图片(带边框)
    func getRoundRectImage(_ size : CGFloat, _ radius : CGFloat, _ borderWidth : CGFloat?, _ borderColor : UIColor?) -> UIImage {
        
        let scale = self.size.width / size ;
        
        //初始值
        var defaultBorderWidth : CGFloat = 0
        var defaultBorderColor = UIColor.clear
        
        if let borderWidth = borderWidth { defaultBorderWidth = borderWidth * scale }
        if let borderColor = borderColor { defaultBorderColor = borderColor }
        
        let radius = radius * scale
        let react = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()
        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
    }
}


