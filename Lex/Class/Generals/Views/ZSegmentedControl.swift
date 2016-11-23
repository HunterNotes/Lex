//
//  ZSegmentedControl.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/25.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

class ZSegmentedControl: UISegmentedControl {

    var segmentedControl:ZSegmentedControl!
    
    //UISegmentedControl iOS中的分段控件,由多个分段组成,每一段相当于一个button.切换分段,对应着切换显示内容.
    func newSegmentedControl(_ arr: NSArray) -> ZSegmentedControl {

        segmentedControl = ZSegmentedControl.init(items: arr as [AnyObject])
        segmentedControl.frame = CGRect(x: 37.5, y: 60, width: 300, height: 30)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.red
        segmentedControl.layer.cornerRadius = 2.5
        segmentedControl.setWidth(100, forSegmentAt: arr.count - 1)
        segmentedControl.isMomentary = false
        segmentedControl.layer.borderColor = UIColor.cyan.cgColor
        segmentedControl.addTarget(self, action:#selector(handleControl), for: .valueChanged)
        return segmentedControl
    }
    
    func handleControl() {
        
    }
}
