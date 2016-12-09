//
//  LaunchCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/9.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

class LaunchCell: UICollectionViewCell {
    
    var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "walkthrough_\(imageIndex! + 1)")
        }
    }
    
    func startBtnAnimation() {
        
        startButton.isHidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        
        // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 清空形变
            self.startButton.transform = CGAffineTransform.identity
        }, completion: { (_) -> Void in
            self.startButton.isUserInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        lView = leapfrogView
        contentView.addSubview(iconView)
        contentView.addSubview(lView!)
        contentView.addSubview(startButton)
        
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-50)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.centerX.equalTo(contentView.centerX)
        }
    }
    
    //MARK: 带跳过按钮视图
    lazy var leapfrogView : LeapfrogView = {
        
        let leapfrog : LeapfrogView = LeapfrogView()
        leapfrog.backgroundColor = UIColor.clear
        leapfrog.frame = CGRect.init(x: app_width - 80, y: 30, width: 41, height: 41)
        return leapfrog
    }()
    
    lazy var iconView = UIImageView()
    
    //MARK: 开始按钮
    lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "btn_begin"), for: UIControlState())
        btn.layer.masksToBounds = true
        btn.isHidden = true
        return btn
    }()
    
}
