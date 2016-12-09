//
//  ProgressView.swift
//  Lex
//
//  Created by nbcb on 2016/12/8.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

//环形进度条
@IBDesignable class ProgressView: UIView {
    
    struct Constant {
        
        //进度条宽度
        static let lineWidth: CGFloat = 2
        
        //进度槽颜色
        static let trackColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        
        //进度条颜色
        static let progressColoar = UIColor.orange
    }
    
    //进度槽
    let trackLayer = CAShapeLayer()
    
    //进度条
    let progressLayer = CAShapeLayer()
    
    //进度条路径（整个圆圈）
    let path = UIBezierPath()
    
    //当前进度
    @IBInspectable var progress: Double = LAUNCHPROGRESS {
        
        didSet {
            
            if progress > 100 {
                progress = 100
            }
            else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        
        //获取整个进度条圆圈路径
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: bounds.size.width / 2 - Constant.lineWidth,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        //绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        //绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        layer.addSublayer(progressLayer)
    }
    
    //设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Double, animated anim: Bool) {
        
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    //设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Double, animated anim: Bool, withDuration duration: Double) {
        
        progress = pro
        
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        CATransaction.commit()
    }
    
    //将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double) -> CGFloat {
        
        return CGFloat(angle / Double(180.0) * M_PI)
    }
}
