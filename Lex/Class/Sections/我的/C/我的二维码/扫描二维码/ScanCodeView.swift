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
    
    //MARK: 初始化后调用
    func newViews() {
        
        _ = self.scanPane
        _ = self.scanLine
        _ = self.activityIndicatorView
        _ = self.topView
        _ = self.alertTitle
        _ = self.leftView
        _ = self.rightView
        _ = self.bottomView
        _ = self.tabBarView
    }
    
    //扫描框
    lazy var scanPane : UIImageView = {
        
        weak var weakSelf : ScanCodeView? = self
        let imgView : UIImageView = UIImageView(image: UIImage(named: "QRCode_ScanBox"))
        imgView.alpha = 0.3
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(weakSelf!)
            make.size.equalTo(CGSize(width: ScanCode_Height, height: ScanCode_Height))
        }
        return imgView
    }()
    
    //MARK: 扫描框动画
    lazy var scanLine : UIImageView = {
        
        let line = UIImageView.init(image: UIImage.init(named: "QRCode_ScanLine"))
        
        //此处不能➕约束，block异步，导致实际加约束时间延迟
        line.frame = CGRect.init(x: 0, y: 0, width: ScanCode_Height, height: 3)
        self.scanPane.addSubview(line)
        return line
    }()
    
    //指示器
    lazy var activityIndicatorView : UIActivityIndicatorView = {
        
        let activity : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        activity.color = UIColor.white
        self.scanPane.addSubview(activity)
        weak var weakSelf : ScanCodeView? = self
        activity.snp.makeConstraints { (make) -> Void in
            make.center.equalTo((weakSelf?.scanPane)!)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        return activity
    }()
    
    //扫描框👆视图
    lazy var topView : UIView = {
        
        let top : UIView = UIView()
        top.backgroundColor = UIColor.black
        top.alpha = 0.8
        self.addSubview(top)
        weak var weakSelf : ScanCodeView? = self
        top.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width:app_width, height:ScanCode_Height))
        }
        return top
    }()
    
    //扫描框👆文字
    lazy var alertTitle : UILabel = {
        
        let title : UILabel = UILabel()
        title.backgroundColor = UIColor.black
        title.alpha = 0.8
        title.text = "将取景框对准二维/条形码，即可自动扫描"
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.topView.addSubview(title)
        weak var weakSelf : ScanCodeView? = self
        title.snp.makeConstraints { (make) -> Void in
            make.left.equalTo((weakSelf?.topView)!).offset(20)
            make.right.equalTo((weakSelf?.topView)!).offset(-20)
            make.bottom.equalTo((weakSelf?.topView)!).offset(-30)
            make.height.equalTo(16)
        }
        return title
    }()
    
    //扫描框👈视图
    lazy var leftView : UIView = {
        
        let left : UIView = UIView()
        left.backgroundColor = UIColor.black
        left.alpha = 0.8
        self.addSubview(left)
        weak var weakSelf : ScanCodeView? = self
        left.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(ScanCode_Height)
            make.size.equalTo(CGSize(width:ScanCode_Space, height:ScanCode_Height))
        }
        return left
    }()
    
    //扫描框👉视图
    lazy var rightView : UIView = {
        
        let right : UIView = UIView()
        right.backgroundColor = UIColor.black
        right.alpha = 0.8
        self.addSubview(right)
        weak var weakSelf : ScanCodeView? = self
        right.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(ScanCode_Height)
            make.size.equalTo(CGSize(width:ScanCode_Space, height:ScanCode_Height))
        }
        return right
    }()
    
    //扫描框👇视图
    lazy var bottomView : UIView = {
        
        var bottom : UIView = UIView()
        bottom.backgroundColor = UIColor.black
        bottom.alpha = 0.8
        self.addSubview(bottom)
        weak var weakSelf : ScanCodeView? = self
        bottom.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width: app_width, height:ScanCode_Height))
        }
        return bottom
    }()
    
    //底部指示器
    lazy var tabBarView : TabBarView = {
        
        var tabBarViews : TabBarView = TabBarView()
        tabBarViews.newView()
        tabBarViews.backgroundColor = UIColor.black
        tabBarViews.alpha = 0.4
        self.addSubview(tabBarViews)
        weak var weakSelf : ScanCodeView? = self
        tabBarViews.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width: app_width, height: 80))
        }
        return tabBarViews
    }()
}
