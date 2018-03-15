//
//  LoadingVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/15.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

class LoadingVC: UIViewController {
    
    var isFirstLaunch : Bool = false
    var timer         : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func judjeCrashInfo()  {
        
        setupUI()
        getAppLaunchInfo()
    }
    
    //MARK: - 检测app是不是第一次启动
    fileprivate func getAppLaunchInfo() {
        
        if !UserDefaults.standard.bool(forKey: FirstLaunch) {
            
            isFirstLaunch = true
            self.progressView.isHidden = true
            UserDefaults.standard.set(true, forKey: FirstLaunch)
        }
        else {
            isFirstLaunch = false
            self.progressView.isHidden = false
        }
    
        let timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        timer.fire()
    }

    fileprivate func setupUI() {
        
        weak var weakSelf = self
        self.view.addSubview(self.progressView)
        
        self.progressView.snp.makeConstraints { (make) in
            make.top.equalTo((weakSelf?.view)!).offset(40)
            make.right.equalTo((weakSelf?.view)!).offset(-20)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
    }
    
    fileprivate lazy var progressView : ProgressView = {
        
        var progress : ProgressView = ProgressView()
        progress.backgroundColor = .clear
        progress.progressColoar = .cyan
        return progress
    }()
    
    @objc fileprivate func countDown(_ sender : Timer) {
        
        timer += 1
        if isFirstLaunch {
            if timer >= 2 {
                sender.invalidate()
                UIApplication.shared.keyWindow?.rootViewController = UserGuideVC()
            }
        }
        else {
            if timer >= 2 {
                
                var pro : Double = self.progressView.progress
                pro -= 90
                self.progressView.setProgress(pro, animated: true)
                
                if pro <= -90 { //进度条显示实际进度延迟约1秒，确保进度条走完才进入主界面
                    sender.invalidate()
                    enterMainInterface()
                }
            }
        }
    }
}
