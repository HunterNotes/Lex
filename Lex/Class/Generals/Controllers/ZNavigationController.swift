//
//  ZNavigationController.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/29.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

class ZNavigationController: UINavigationController {
    
    internal override class func initialize () {
        super.initialize()
        //设置导航栏标题
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.white
        bar.barTintColor = nav_color()
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:UIFont.systemFont(ofSize: 20.0)]
    }
    
    /**
     * 统一设置导航栏左上角的back按钮
     *
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            
            super.pushViewController(viewController, animated: true)
            //push后隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back_red"), style: .plain, target: self, action: #selector(doBack))
        }
    }
    
    func doBack() {
        
        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        self.popViewController(animated: true)
    }
}
