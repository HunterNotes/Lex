//
//  PresentNaBarView.swift
//  Lex
//
//  Created by nbcb on 2016/12/22.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

/*
 * present时使用 高度64 左右带按钮
 */
class PresentNaBarView: UIView {
    
    
    lazy var cancelBtn : UIButton = {
        
        let button : UIButton = UIButton.init(type: UIButtonType.custom)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var saveBtn : UIButton = {
        
        let button : UIButton = UIButton.init(type: UIButtonType.custom)
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.green, for: .normal)
        return button
    }()
    
    lazy var naBarItem : UILabel = {
        
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = CGRect.init(x: 0, y: 0, width: app_width, height: 64)
        
        self.addSubview(self.cancelBtn)
        self.cancelBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.bottom.equalTo(-7)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        self.addSubview(self.saveBtn)
        self.saveBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-15)
            make.bottom.equalTo(-7)
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        self.addSubview(self.naBarItem)
        self.naBarItem.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(65)
            make.right.equalTo(-65)
            make.bottom.equalTo(-7)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
