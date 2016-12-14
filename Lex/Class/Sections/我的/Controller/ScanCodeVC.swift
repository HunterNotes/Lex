//
//  ScanCodeVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/6.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit


class ScanCodeVC: UIViewController {
    
    private let scanAnimationDuration : Double = 3.0 //扫描时长
    var lightOn       : Bool = false //闪光灯
    var scanSession   : AVCaptureSession?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "二维码扫描"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = self.scanCodeView
        setupScanSession()
        startScan()
    }
    
    lazy var scanCodeView : ScanCodeView = {
        
        var scanCode : ScanCodeView = ScanCodeView()
        scanCode.newViews()
        
        scanCode.tabBarView.photoBtn.addTarget(self, action: #selector(photo), for: .touchUpInside)
        scanCode.tabBarView.lightBtn.addTarget(self, action: #selector(light), for: .touchUpInside)
        scanCode.tabBarView.myQRCodeBtn.addTarget(self, action: #selector(myQRCode), for: .touchUpInside)
        
        self.view.addSubview(scanCode)
        weak var weakSelf : ScanCodeVC? = self
        scanCode.snp.makeConstraints { (make) -> Void in
            make.top.equalTo((weakSelf?.view)!).offset(0)
            make.left.equalTo((weakSelf?.view)!).offset(0)
            make.size.equalTo(CGSize.init(width: app_width, height: app_height))
        }
        return scanCode
    }()
    
    //MARK: Action - 相册
    func photo(sender : UIButton) {
        
        weak var weakSelf : ScanCodeVC? = self
        //[weak self]
        ScanCodeTool.shareTool().choosePicture(self, true, .photoLibrary) {/*[weak self]*/ (image) in
            weakSelf?.scanCodeView.activityIndicatorView.startAnimating()
            
            DispatchQueue.global().async {
                let recognizeResult = image.recognizeQRCode()
                let result = recognizeResult?.characters.count > 0 ? recognizeResult : "无法识别"
                DispatchQueue.main.async {
                    weakSelf?.scanCodeView.activityIndicatorView.stopAnimating()
                    ScanCodeTool.confirm("扫描结果", result, weakSelf!)
                }
            }
        }
    }
    
    //MARK: Action - 灯光
    func light(sender : UIButton) {
        
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
    }
    
    //MARK: Action - 我的二维码
    func myQRCode(sender : UIButton) {
        
        let vc = MyQRCodeVC()
        vc.pushFlag = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Interface Components
    func setupScanSession() {
        
        do {
            
            //设置捕捉设备
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            //设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.global()) //main
            
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            if scanSession.canAddInput(input) {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output) {
                scanSession.addOutput(output)
            }
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            scanPreviewLayer!.frame = view.layer.bounds
            
            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
            
            weak var weakSelf : ScanCodeVC! = self
            
            /* 此处不能使用weakSelf 会crash */
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: weakSelf.scanCodeView.scanPane.frame))!
            })
            
            //保存会话
            self.scanSession = scanSession
        }
        catch {
            
            //摄像头不可用
            ScanCodeTool.confirm("提示", "摄像头不可用", self)
            return
        }
    }
    //开始扫描
    fileprivate func startScan() {
        
        self.scanCodeView.scanLine.layer.add(scanAnimation(), forKey: "scan")
        
        guard let scanSession = scanSession else { return }
        
        if !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation {
        
        let startPoint = CGPoint(x: (self.scanCodeView.scanLine.center.x)  , y: 1)
        let endPoint = CGPoint(x: (self.scanCodeView.scanLine.center.x), y: ScanCode_Height - 2)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    
    ///闪光灯
    private func turnTorchOn() {
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            
            if lightOn {
                ScanCodeTool.confirm("提示", "闪光灯不可用", self)
            }
            return
        }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if lightOn && device.torchMode == .off {
                    device.torchMode = .on
                }
                if !lightOn && device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch { }
        }
    }
    
    deinit  {
        
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScanCodeVC : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //停止扫描
        self.scanCodeView.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        ScanCodeTool.playAlertSound("noticeMusic.caf")
        
        weak var weakSelf : ScanCodeVC? = self
        
        //扫完完成
        if metadataObjects.count > 0 {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                
                ScanCodeTool.confirm("扫描结果", resultObj.stringValue, weakSelf!, handler: { (_) in
                    //继续扫描
                    weakSelf?.startScan()
                })
            }
        }
    }
}

//MARK: - ScanCodeView
class ScanCodeView: UIView {
    
    //MARK: 初始化后调用
    func newViews() {
        
        _ = self.scanPane
        _ = self.scanLine
        _ = self.activityIndicatorView
        _ = self.topView
        _ = self.alertTitle
        _ = self.leftView
        _ = self.rightView
        _ = self.bottomView
        _ = self.tabBarView
    }
    
    //扫描框
    lazy var scanPane : UIImageView = {
        
        weak var weakSelf : ScanCodeView? = self
        let imgView : UIImageView = UIImageView(image: UIImage(named: "QRCode_ScanBox"))
        imgView.alpha = 0.3
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(weakSelf!)
            make.size.equalTo(CGSize(width: ScanCode_Height, height: ScanCode_Height))
        }
        return imgView
    }()
    
    //MARK: 扫描框动画
    lazy var scanLine : UIImageView = {
        
        let line = UIImageView.init(image: UIImage.init(named: "QRCode_ScanLine"))
        
        //此处不能➕约束，block异步，导致实际加约束时间延迟
        line.frame = CGRect.init(x: 0, y: 0, width: ScanCode_Height, height: 3)
        self.scanPane.addSubview(line)
        return line
    }()
    
    //指示器
    lazy var activityIndicatorView : UIActivityIndicatorView = {
        
        let activity : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        activity.color = UIColor.white
        self.scanPane.addSubview(activity)
        weak var weakSelf : ScanCodeView? = self
        activity.snp.makeConstraints { (make) -> Void in
            make.center.equalTo((weakSelf?.scanPane)!)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        return activity
    }()
    
    //扫描框👆视图
    lazy var topView : UIView = {
        
        let top : UIView = UIView()
        top.backgroundColor = UIColor.black
        top.alpha = 0.8
        self.addSubview(top)
        weak var weakSelf : ScanCodeView? = self
        top.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width:app_width, height:ScanCode_Height))
        }
        return top
    }()
    
    //扫描框👆文字
    lazy var alertTitle : UILabel = {
        
        let title : UILabel = UILabel()
        title.backgroundColor = UIColor.black
        title.alpha = 0.8
        title.text = "将取景框对准二维/条形码，即可自动扫描"
        title.textAlignment = .center
        title.textColor = UIColor.white
        self.topView.addSubview(title)
        weak var weakSelf : ScanCodeView? = self
        title.snp.makeConstraints { (make) -> Void in
            make.left.equalTo((weakSelf?.topView)!).offset(20)
            make.right.equalTo((weakSelf?.topView)!).offset(-20)
            make.bottom.equalTo((weakSelf?.topView)!).offset(-30)
            make.height.equalTo(16)
        }
        return title
    }()
    
    //扫描框👈视图
    lazy var leftView : UIView = {
        
        let left : UIView = UIView()
        left.backgroundColor = UIColor.black
        left.alpha = 0.8
        self.addSubview(left)
        weak var weakSelf : ScanCodeView? = self
        left.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(ScanCode_Height)
            make.size.equalTo(CGSize(width:ScanCode_Space, height:ScanCode_Height))
        }
        return left
    }()
    
    //扫描框👉视图
    lazy var rightView : UIView = {
        
        let right : UIView = UIView()
        right.backgroundColor = UIColor.black
        right.alpha = 0.8
        self.addSubview(right)
        weak var weakSelf : ScanCodeView? = self
        right.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(ScanCode_Height)
            make.size.equalTo(CGSize(width:ScanCode_Space, height:ScanCode_Height))
        }
        return right
    }()
    
    //扫描框👇视图
    lazy var bottomView : UIView = {
        
        var bottom : UIView = UIView()
        bottom.backgroundColor = UIColor.black
        bottom.alpha = 0.8
        self.addSubview(bottom)
        weak var weakSelf : ScanCodeView? = self
        bottom.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width: app_width, height:ScanCode_Height))
        }
        return bottom
    }()
    
    //底部指示器
    lazy var tabBarView : TabBarView = {
        
        var tabBarViews : TabBarView = TabBarView()
        tabBarViews.newView()
        tabBarViews.backgroundColor = UIColor.black
        tabBarViews.alpha = 0.4
        self.addSubview(tabBarViews)
        weak var weakSelf : ScanCodeView? = self
        tabBarViews.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
            make.size.equalTo(CGSize(width: app_width, height: 80))
        }
        return tabBarViews
    }()
}

//MARK: - TabBarView
class TabBarView : UIView {
    
    lazy var top : CGFloat = {
        
        return 10
    }()
    
    lazy var w : CGFloat = {
        
        return 45
    }()
    
    lazy var h : CGFloat = {
        
        return 60
    }()
    
    lazy var space : CGFloat = {
        
        return (app_width - self.w * 3) / 4
    }()
    
    //MARK: 初始化后调用
    func newView() {
        
        _ = self.photoBtn
        _ = self.lightBtn
        _ = self.myQRCodeBtn
    }
    
    //相册
    lazy var photoBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_photo_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.left.equalTo(weakSelf!).offset((weakSelf?.space)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
    
    //灯光
    lazy var lightBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_flash_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.left.equalTo(weakSelf!).offset((weakSelf?.space)! * 2 + (weakSelf?.w)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
    
    //我的二维码
    lazy var myQRCodeBtn : UIButton = {
        
        weak var weakSelf : TabBarView? = self
        let button : UIButton = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "qrcode_scan_btn_myqrcode_nor"), for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(weakSelf!).offset((weakSelf?.top)!)
            make.right.equalTo(weakSelf!).offset(-(weakSelf?.space)!)
            make.size.equalTo(CGSize.init(width: (weakSelf?.w)!, height: (weakSelf?.h)!))
        }
        return button
    }()
}

