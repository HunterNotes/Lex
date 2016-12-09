//
//  LeapfrogView.swift
//  Lex
//
//  Created by nbcb on 2016/12/9.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit


/// 带跳过按钮的视图
class LeapfrogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        
        addSubview(progressView)
        progressView.addSubview(leapfrogBtn)
    }
    
    //MARK: 跳过按钮外层环
    lazy var progressView : ProgressView = {
        
        let progress : ProgressView = ProgressView()
        progress.backgroundColor = UIColor.clear
        progress.frame = CGRect.init(x: 0, y: 0, width: 42, height: 42)
        return progress
    }()
    
    //MARK: 跳过按钮
    lazy var leapfrogBtn : UIButton = {
        
        let button = UIButton()
        button.setTitle("跳过\(LAUNCHCOUNTDOWN)s", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //此处绘图需要设置frame, 故不使用SnapKit
        let rec : CGRect = CGRect.init(x: 3.5, y: 3.5, width: 35, height: 35)
        button.frame = rec
        button.drawCorner(rec, .allCorners, 20, .cyan, 1.5)
        return button
    }()
}
