//
//  BaseViewController.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SVProgressHUD
import FDFullscreenPopGesture

class BaseViewController: UIViewController {
    
    var navTitle: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.navTitle
        view.backgroundColor = globalBGColor()
        navigationController?.fd_prefersNavigationBarHidden = true
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
    }
}
