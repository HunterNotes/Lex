//
//  TabBarView.swift
//  Lex
//
//  Created by nbcb on 2016/12/5.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

class TabBarView : UIView {
    
    lazy var top : CGFloat = {
        
        return 10
    }()
    
    lazy var w : CGFloat = {
        
        return 45
    }()
    
    lazy var h : CGFloat = {
        
        return 60
    }()
    
    lazy var space : CGFloat = {
        
        return (app_width - self.w * 3) / 4
    }()
    
    //MARK: 初始化后调用
    func newView() {
        
        _ = self.photoBtn
        _ = self.lightBtn
        _ = self.myQRCodeBtn
    }
    
    //相册
    lazy var photoBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_photo_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.left.equalTo(weakSelf!).offset((weakSelf?.space)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
    
    //灯光
    lazy var lightBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_flash_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.left.equalTo(weakSelf!).offset((weakSelf?.space)! * 2 + (weakSelf?.w)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
    
    //我的二维码
    lazy var myQRCodeBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_myqrcode_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.right.equalTo(weakSelf!).offset(-(weakSelf?.space)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
}
