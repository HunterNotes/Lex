//
//  ScanCodeLoadingView.swift
//  Lex
//
//  Created by nbcb on 2016/12/20.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

/*
 size(100, 100)
 */

class ScanCodeLoadingView: UIView {
    
    lazy var activity: UIActivityIndicatorView = {
        
        let activity : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        return activity
    }()
    
    lazy var loadingText: UILabel = {
        
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "正在加载……"
        
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        weak var weakSelf = self
        self.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.center.equalTo(weakSelf!)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        self.addSubview(loadingText)
        loadingText.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(weakSelf!).offset(0)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
