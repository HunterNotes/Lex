//
//  LaunchViewController.swift
//  Lex
//
//  Created by cc on 2016/11/25.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

class LaunchViewController: UICollectionViewController {
    
    let kNewFeatureCount    = 4
    let newFeatureID        = "newFeatureID"
    
    // 布局对象
    fileprivate var layout: UICollectionViewFlowLayout = CollectionViewLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: newFeatureID)
    }
}

extension LaunchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNewFeatureCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item : Int = (indexPath as NSIndexPath).item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFeatureID, for: indexPath) as! CollectionViewCell
        cell.imageIndex = item
        cell.leapfrogBtn.isHidden = (item == 0) ? false : true
        cell.startButton.isHidden = (item == kNewFeatureCount - 1) ? false : true
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems.last!
        let cell = collectionView.cellForItem(at: path) as! CollectionViewCell
        if path.item == (kNewFeatureCount - 1) {
            cell.startBtnAnimation()
        }
        else {
            cell.startButton.isHidden = true
        }
    }
}

/// YMNewfeatureCell
private class CollectionViewCell: UICollectionViewCell {
    
    var time                : TimeInterval = 0.0

    fileprivate var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "walkthrough_\(imageIndex! + 1)")
        }
    }
    
    func startBtnAnimation() {
        
        startButton.isHidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        
        // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 清空形变
            self.startButton.transform = CGAffineTransform.identity
        }, completion: { (_) -> Void in
            self.startButton.isUserInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.addSubview(iconView)
        contentView.addSubview(leapfrogBtn)
        contentView.addSubview(startButton)
        contentView.addSubview(progressView)
        
        
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-50)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.centerX.equalTo(contentView.centerX)
        }
    }
    
    fileprivate lazy var iconView = UIImageView()
    
    //MARK: 跳过按钮外层环
    fileprivate lazy var progressView : ProgressView = {
        
        let progress : ProgressView = ProgressView()
        progress.frame = CGRect.init(x: app_width - 80, y: 30, width: 80, height: 80)
        let timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        self.time = 0.0
        timer.fire()
        return progress
        
    }()
    
    func timer(_ sender : Timer) {
        
       self.time += 1
        if self.time == 10 {
            sender.invalidate()
        }
        progressView.setProgress(progressView.progress - (progressView.progress / 10), animated: true)
    }
    
    //MARK: 跳过按钮
    fileprivate lazy var leapfrogBtn : UIButton = {
        
        let button = UIButton()
        button.setTitle("跳过", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(leapfrog), for: .touchUpInside)
        button.isHidden = true
        
        //此处绘图需要设置frame, 故不使用SnapKit
        let rec : CGRect = CGRect.init(x: app_width - 80, y: 30, width: 40, height: 40)
        button.frame = rec
        button.drawCorner(rec, .allCorners, 20, .orange, .clear, 1.0)
        return button
    }()
    
    func leapfrog() {
        
        startButtonClick()
    }
    
    //MARK: 开始按钮
    fileprivate lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "btn_begin"), for: UIControlState())
        btn.addTarget(self, action: #selector(startButtonClick), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    @objc func startButtonClick() {
        UIApplication.shared.keyWindow?.rootViewController = ZTabBarController()
    }
}

private class CollectionViewLayout: UICollectionViewFlowLayout {
    
    /// 准备布局
    fileprivate override func prepare() {
        // 设置 layout 布局
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 设置 contentView 属性
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
