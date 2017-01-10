//
//  PageNavigationVC.swift
//  Swift
//
//  Created by nbcb on 16/3/16.
//  Copyright © 2016年 nbcb. All rights reserved.
//

import UIKit

class PageNavigationVC : BaseViewController, PopMenuDelegate {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navTitle = "导航"
        self.menuView.delegate = self
        self.view.addSubview(self.menuView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.menuView.showMenuView()
    }
    
    lazy var menuView : PopMenu = {
        
        let menuView : PopMenu = PopMenu.init(frame: self.view.frame)
        return menuView
    }()
    
    func didClickMenu(_ index: Int) {
        print("click at \(index)")
        
        switch index {
        case 0:
            //我的名字
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserNameVC") as! UserNameVC
            UIView.transition(from: self.view, to: vc.view, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, completion: { (finish : Bool) in
                //动画
            })
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            //拍照
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserPhotoVC") as! UserPhotoVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            //扫描二维码
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ScanCodeVC") as! ScanCodeVC
            UIView.transition(from: self.view, to: vc.view, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, completion: { (finish : Bool) in
                //动画
            })
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            //二维码扫描结果
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ScanCodeResultVC") as! ScanCodeResultVC
            vc.urlStr = QRTEXT
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            //地图
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            self.present(vc, animated: true, completion: nil)
            break
        case 5:
            //我的地址
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UpDateAddressVC") as! UpDateAddressVC
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}
