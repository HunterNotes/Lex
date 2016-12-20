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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = globalBGColor()
        navigationController?.fd_prefersNavigationBarHidden = true
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }

    func pushVC(_ storyboardName : String, _ vcName : String) {
        
        let vc = UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: vcName) as! BaseViewController
        UIView.transition(from: self.view, to: vc.view, duration: 0.1, options: UIViewAnimationOptions.transitionCrossDissolve, completion: { (finish : Bool) in
            //动画
        })
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
