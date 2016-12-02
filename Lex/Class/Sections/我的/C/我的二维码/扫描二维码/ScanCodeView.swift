//
//  ScanCodeView.swift
//  Lex
//
//  Created by nbcb on 2016/12/2.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

class ScanCodeView: UIView {
    
    //    weak var scanPane               : UIImageView! ///扫描框
    //    weak var activityIndicatorView  : UIActivityIndicatorView!
    //    weak var topView                : UIView!
    //    weak var leftView               : UIView!
    //    weak var bottomView             : UIView!
    //    weak var rightView              : UIView!
    //    weak var tabBarView             : UIView!
    
    var weakSelf : ScanCodeView {
        
        weak var _weakSelf : ScanCodeView? = self
        return _weakSelf!
    }
    
    let common_Height : CGFloat = app_height / 3
    let center_space : CGFloat = (app_width - (app_height / 3)) / 2
    
    //扫描框
    weak var scanPane : UIImageView? {
        
        let imgView : UIImageView = UIImageView(image: UIImage(named: "QRCode_ScanBox"))
        imgView.alpha = 0.2
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(weakSelf)
            make.size.equalTo(CGSize(width: common_Height, height: common_Height))
        }
        return imgView
    }
    
    //指示器
    weak var activityIndicatorView  : UIActivityIndicatorView? {
        
        let activity : UIActivityIndicatorView = UIActivityIndicatorView()
        activity.color = UIColor.orange
        self.scanPane?.addSubview(activity)
        activity.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(weakSelf.scanPane!)
            make.size.equalTo(CGSize(width: 37, height: 37))
        }
        return activity
    }
    
    //扫描框👆视图
    weak var topView : UIView? {
        
        let top : UIView = UIView()
        top.backgroundColor = UIColor.black
        top.alpha = 0.6
        self.addSubview(top)
        top.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf).offset(0)
            make.top.equalTo(weakSelf).offset(0)
            make.size.equalTo(CGSize(width: app_width, height: common_Height))
        }
        return top
    }
    
    //扫描框👆文字
    weak var alertTitle : UILabel? {
        
        let title : UILabel = UILabel()
        title.backgroundColor = UIColor.clear
        title.text = "将取景框对准二维/条形码，即可自动扫描"
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.topView?.addSubview(title)
        title.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf.topView!).offset(65)
            make.right.equalTo(weakSelf.topView!).offset(65)
            make.bottom.equalTo(weakSelf.topView!).offset(30)
            make.height.equalTo(16)
        }
        
        return title
    }
    //扫描框👈视图
    weak var leftView : UIView? {
        
        let left : UIView = UIView()
        left.backgroundColor = UIColor.black
        left.alpha = 0.6
        self.addSubview(left)
        left.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf).offset(0)
            make.top.equalTo(weakSelf).offset(common_Height)
            make.size.equalTo(CGSize(width: center_space, height: common_Height))
        }
        return left
    }
    
    //扫描框👉视图
    weak var rightView : UIView? {
        
        let right : UIView = UIView()
        right.backgroundColor = UIColor.black
        right.alpha = 0.6
        self.addSubview(right)
        right.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(weakSelf).offset(0)
            make.top.equalTo(weakSelf).offset(common_Height)
            make.size.equalTo(CGSize(width: center_space, height: common_Height))
        }
        return right
    }
    
    //扫描框👇视图
    weak var bottomView : UIView? {
        
        let bottom : UIView = UIView()
        bottom.backgroundColor = UIColor.black
        bottom.alpha = 0.6
        self.addSubview(bottom)
        bottom.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf).offset(0)
            make.right.equalTo(weakSelf).offset(0)
            make.size.equalTo(CGSize(width: app_width, height: common_Height))
        }
        return bottom
    }
    
    //底部指示器
    weak var tabBarView : UIView? {
        
        let tabBar : UIView = UIView()
        tabBar.backgroundColor = UIColor.black
        tabBar.alpha = 0.6
        self.addSubview(tabBar)
        tabBar.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf).offset(0)
            make.right.equalTo(weakSelf).offset(0)
            make.size.equalTo(CGSize(width: app_width, height: 80))
        }
        return tabBar
    }
}
