//
//  UserGuideVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/14.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

var lView               : LeapfrogView? = nil

class UserGuideVC : UICollectionViewController {
    
    let launchPageCount  : Int      = 3
    let newFeatureID     : String   = "newFeatureID"
    let pro              : Double   = LAUNCHPROGRESS / (LAUNCHCOUNTDOWN / 0.1)
    var countDown        : Int      = Int(LAUNCHCOUNTDOWN / 0.1)
    var timer            : Timer!
    var indexPathItem    : Int?     = 0
    
    // 布局对象
    fileprivate var layout: UICollectionViewFlowLayout = UserGuideCellLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(UserGuideCell.self, forCellWithReuseIdentifier: newFeatureID)
        
        timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        timer.fire()
    }
    
    @objc fileprivate func timer(_ sender : Timer) {
        
        if lView != nil {
            
            countDown -= 1
            
            var count : Int = Int(countDown)
            
            if countDown >= 20 && countDown < 30 {
                count = 3
            }
            else if countDown >= 10 && countDown < 20 {
                count = 2
            }
            else if countDown > 0 && countDown < 10 {
                count = 1
            }
            else if countDown == 0 {
                count = 0
            }
            if count >= 0 {
                lView?.leapfrogBtn.setTitle("跳过 \(count)s", for: .normal)
            }
            
            var progress : Double = lView!.progressView.progress
            
            if progress > 0 {
                
                progress -= pro
                lView?.progressView.setProgress(progress, animated: true)
            }
            
            if countDown == -10 { //进度条显示实际进度延迟约1秒，确保进度条走完才进入主界面
                
                sender.invalidate()
                enterMainInterface()
            }
        }
    }
    
    @objc fileprivate func leapfrog(_ sender : UIButton) {
        
        enterMainInterface()
    }
    
    @objc fileprivate func start() {
        
        enterMainInterface()
    }
    
    //MARK: - UICollectionViewDelegate  UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchPageCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item : Int = (indexPath as NSIndexPath).item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFeatureID, for: indexPath) as! UserGuideCell
        cell.imageIndex = item
        cell.startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        cell.startButton.isHidden = (item == launchPageCount - 1) ? false : true
        cell.leapfrogView.isHidden = (item == 0) ? false : true
        cell.leapfrogView.leapfrogBtn.addTarget(self, action: #selector(leapfrog(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems.last!
        let cell = collectionView.cellForItem(at: path) as! UserGuideCell
        self.indexPathItem = path.item
        
        if self.indexPathItem == 0 {
            lView!.progressView.progress = LAUNCHPROGRESS
            countDown = Int(LAUNCHCOUNTDOWN / 0.1)
            lView?.progressView.setProgress(LAUNCHPROGRESS, animated: true)
            timer.fire()
        }
        else {
            timer.invalidate()
            
        }
        if path.item == (launchPageCount - 1) {
            cell.startBtnAnimation()
        }
        else {
            cell.startButton.isHidden = true
        }
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if self.indexPathItem == 0 {
//            lView!.progressView.progress = LAUNCHPROGRESS
//            countDown = Int(LAUNCHCOUNTDOWN / 0.1)
//            lView?.progressView.setProgress(LAUNCHPROGRESS, animated: true)
//            timer.fire()
//        }
//        else {
//            timer.invalidate()
//            
//        }
//        collectionView?.reloadData()
//    }
}

//MARK: - UserGuideCell
class UserGuideCell: UICollectionViewCell {
    
    var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "UserGuide_\(imageIndex! + 1)")
        }
    }
    
    //MARK: - 开始按钮动画
    func startBtnAnimation() {
        
        startButton.isHidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
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
        
        lView = leapfrogView
        contentView.addSubview(iconView)
        contentView.addSubview(lView!)
        contentView.addSubview(startButton)
        
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-50)
            make.size.equalTo(CGSize(width: 150, height: 40))
            make.centerX.equalTo(contentView.centerX)
        }
    }
    
    //MARK: 带跳过按钮视图
    lazy var leapfrogView : LeapfrogView = {
        
        let leapfrog : LeapfrogView = LeapfrogView()
        leapfrog.backgroundColor = .clear
        leapfrog.frame = CGRect.init(x: app_width - 80, y: 30, width: 41, height: 41)
        return leapfrog
    }()
    
    lazy var iconView = UIImageView()
    
    //MARK: 开始按钮
    lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "btn_begin"), for: UIControlState())
        btn.layer.masksToBounds = true
        btn.isHidden = true
        return btn
    }()
}

//MARK: - UserGuideCellLayout
class UserGuideCellLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
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

//MARK: LeapfrogView
class LeapfrogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        
        addSubview(progressView)
        progressView.addSubview(leapfrogBtn)
    }
    
    //MARK: 跳过按钮外层环
    lazy var progressView : ProgressView = {
        
        let progress : ProgressView = ProgressView()
        progress.backgroundColor = UIColor.clear
        progress.frame = CGRect.init(x: 0, y: 0, width: 42, height: 42)
        return progress
    }()
    
    //MARK: 跳过按钮
    lazy var leapfrogBtn : UIButton = {
        
        let button = UIButton()
        button.setTitle("跳过 \(Int(LAUNCHCOUNTDOWN))s", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        
        //此处绘图需要设置frame, 故不添加约束
        let rec : CGRect = CGRect.init(x: 3.5, y: 3.5, width: 35, height: 35)
        button.frame = rec
        button.drawCorner(rec, .allCorners, 20, .cyan, 1.5)
        return button
    }()
}

//MARK: - ProgressView
@IBDesignable class ProgressView: UIView {
    
    //进度条宽度
    var lineWidth : CGFloat = 2
    
    //进度槽颜色
    var trackColor : UIColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
    
    //进度条颜色
    var progressColoar : UIColor = UIColor.orange
    
    //进度槽
    let trackLayer = CAShapeLayer()
    
    //进度条
    let progressLayer = CAShapeLayer()
    
    //进度条路径（整个圆圈）
    let path = UIBezierPath()
    
    //当前进度
    @IBInspectable var progress: Double = LAUNCHPROGRESS {
        
        didSet {
            
            if progress > 100 {
                progress = 100
            }
            else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        
        //获取整个进度条圆圈路径
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: bounds.size.width / 2 - lineWidth,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        //绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        //绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColoar.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        layer.addSublayer(progressLayer)
    }
    
    //设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Double, animated anim: Bool) {
        
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    //设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Double, animated anim: Bool, withDuration duration: Double) {
        
        progress = pro
        
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        CATransaction.commit()
    }
    
    //将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double) -> CGFloat {
        
        return CGFloat(angle / Double(180.0) * M_PI)
    }
}
