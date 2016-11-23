//
//  ZSlider.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/26.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

class ZSlider: UISlider {
    
    var slider: ZSlider!
    
    func newSlider(_ frame: CGRect) -> ZSlider {
        slider = ZSlider.init(frame: frame)
        //改变已经滑过滑竿的颜色
        slider.minimumTrackTintColor = UIColor.red
        //改变未滑过滑竿的颜色
        slider.maximumTrackTintColor = UIColor.green
        //slider设置值的范围
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        //设置slider当前值
        slider.value = 0;
        //添加slider响应事件
        slider.addTarget(self, action:#selector(handleSlider), for: .valueChanged)
        //slider竖直方向
        //设置是否连续触发滑动事件
        slider.isContinuous = true;
        //给slider设置滑块图片
        slider.setThumbImage(UIImage.init(named:""), for: UIControlState())
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }
    
    func handleSlider() {
        
    }
}
