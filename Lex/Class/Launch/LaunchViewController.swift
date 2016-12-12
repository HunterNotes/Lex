//
//  LaunchViewController.swift
//  Lex
//
//  Created by cc on 2016/11/25.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

var lView               : LeapfrogView? = nil

class LaunchViewController: UICollectionViewController {
    
    let launchPageCount  : Int      = 4
    let newFeatureID     : String   = "newFeatureID"
    
    // 布局对象
    fileprivate var layout: UICollectionViewFlowLayout = LaunchCellLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(LaunchCell.self, forCellWithReuseIdentifier: newFeatureID)
        
        let timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        timer.fire()
    }
    
    @objc fileprivate func timer(_ sender : Timer) {
        
        if lView != nil {
            
            LAUNCHCOUNTDOWN = (LAUNCHCOUNTDOWN - 0.5)  //0.5s执行
            if LAUNCHCOUNTDOWN >= 0 {
                
                lView?.leapfrogBtn.setTitle("跳过 \(Int(LAUNCHCOUNTDOWN))s", for: .normal)
            }
            var progress : Double = lView!.progressView.progress
            
            progress -= (LAUNCHPROGRESS / 6.0)
            lView?.progressView.setProgress(progress, animated: true)
            
            if progress <= 0 {
                
                sender.invalidate()
                startButtonClick()
            }
        }
    }
    
    @objc fileprivate func leapfrog(_ sender : UIButton) {
        
        startButtonClick()
    }
    
    @objc fileprivate func startButtonClick() {
        UIApplication.shared.keyWindow?.rootViewController = ZTabBarController()
    }
}

extension LaunchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchPageCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item : Int = (indexPath as NSIndexPath).item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFeatureID, for: indexPath) as! LaunchCell
        cell.imageIndex = item
        cell.startButton.addTarget(self, action: #selector(startButtonClick), for: .touchUpInside)
        cell.startButton.isHidden = (item == launchPageCount - 1) ? false : true
        cell.leapfrogView.isHidden = (item == 0) ? false : true
        cell.leapfrogView.leapfrogBtn.addTarget(self, action: #selector(leapfrog(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems.last!
        let cell = collectionView.cellForItem(at: path) as! LaunchCell
        if path.item == (launchPageCount - 1) {
            cell.startBtnAnimation()
        }
        else {
            cell.startButton.isHidden = true
        }
    }
}
