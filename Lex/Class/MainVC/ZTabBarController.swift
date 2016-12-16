//
//  ZTabBarController.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/29.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

class ZTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        tabBar.tintColor = UIColor.red
        tabBar.barTintColor = base_color()
        addChildViewControllers()
    }
    
    //添加子控制器
    fileprivate func addChildViewControllers() {
        
        let pnVC = UIStoryboard(name: "PageNavigation", bundle: nil).instantiateViewController(withIdentifier: "PageNavigationVC") as! PageNavigationVC
        
        let hpVC = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
        
        let dVC = UIStoryboard(name: "Detection", bundle: nil).instantiateViewController(withIdentifier: "DetectionVC") as! DetectionVC
        
        let ucVC = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterVC") as! UserCenterVC
        
        addChildViewController(pnVC, title: "导航", imageName: "tabbar_discover")
        addChildViewController(hpVC, title: "首页", imageName: "tabbar_home")
        addChildViewController(dVC, title: "发现", imageName: "tabbar_Detection")
        addChildViewController(ucVC, title: "我的", imageName: "tabbar_profile")
        
    }
    //过滤空格
    //        string = string.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
    
    /**
     * childControllerName: 需要初始化的视图控制器
     * title: 标题
     * imageName:图片名称
     */
    func addChildViewController(_ vc: UIViewController, title: String, imageName: String) {
        
        //        // 动态获取命名空间
        //        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        //        // 将字符串转化为类，默认情况下命名空间就是项目名称，但是命名空间可以修改
        //        let cls: AnyClass? = NSClassFromString(childControllerName)
        //        let vcClass = cls as! UIViewController.Type
        //        let vc = vcClass.init()
        // 设置对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_sel")
        vc.title = title
        
        // 给每个控制器包装一个导航控制器
        let nav = ZNavigationController()
        nav.addChildViewController(vc)
        addChildViewController(nav)
    }
}

extension ZTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}

