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
import SVProgressHUD


class ScanCodeVC : BaseViewController {
    
    @IBOutlet weak var scanPane                 : UIImageView! //扫描框
    @IBOutlet weak var activityIndicatorView    : UIActivityIndicatorView!
    
    var countDown                               : Int = 0
    
    fileprivate let scanAnimationDuration           : Double = 3.0 //扫描时长
    var lightOn                                 : Bool = false //闪光灯
    var scanSession                             : AVCaptureSession?
    
    lazy var scanLine : UIImageView = {
        
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 0, width: self.scanPane.bounds.width, height: 3)
        scanLine.image = UIImage(named: "QRCode_ScanLine")
        return scanLine
    }()
    
    lazy var maskView : UIView = {
        
        let view : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: app_height))
        view.backgroundColor = UIColor.black
        self.view.addSubview(view)
        return view
    }()
    
    lazy var loadingView : ScanCodeLoadingView = {
        
        weak var weakSelf = self
        let activity : ScanCodeLoadingView = ScanCodeLoadingView()
        self.maskView.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.center.equalTo((weakSelf?.maskView)!)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        return activity
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "二维码扫描"
        
        loading()
        view.layoutIfNeeded()
        scanPane.addSubview(scanLine)
        setupScanSession()
    }
    
    func loading() {
        
        //        SVProgressHUD.show(withStatus: "加载中……")
        loadingView.activity.startAnimating()
        _ = self.maskView
        let timer : Timer = Timer.init(timeInterval: 1, target: self, selector: #selector(loadingCountDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        timer.fire()
    }
    
    @objc fileprivate func loadingCountDown(_ timer : Timer) {
        
        countDown += 1
        if countDown == 2 {
            loadingView.activity.stopAnimating()
            //            SVProgressHUD.dismiss()
            timer.invalidate()
            maskView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startScan()
    }
    
    //MARK: Action - 相册
    @IBAction func photo(_ sender: UIButton) {
        
        weak var weakSelf = self
        
        ScanCodeTool.shareTool().choosePicture(self, true, .photoLibrary) {[weak self] (image) in
            
            self!.activityIndicatorView.startAnimating()
            
            DispatchQueue.global().async {
                let recognizeResult = image.recognizeQRCode()
                let result = recognizeResult?.characters.count > 0 ? recognizeResult : "无法识别"
                DispatchQueue.main.async {
                    self!.activityIndicatorView.stopAnimating()
                    if reachabilityType! && result != "无法识别" {
                        
                        let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ScanCodeResultVC") as! ScanCodeResultVC
                        vc.urlStr = result
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    ScanCodeTool.confirm("扫描结果", result, self!)
                    //                    ScanCodeTool.confirm("扫描结果", result, weakSelf!, handler: { (_) in
                    //
                    //                    })
                }
            }
        }
    }
    
    //MARK: Action - 灯光
    @IBAction func light(_ sender: UIButton) {
        
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
    }
    
    //MARK: Action - 我的二维码
    @IBAction func myQRCode(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "MyQRCodeVC") as! MyQRCodeVC
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
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
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
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanPane.frame))!
            })
            
            //保存会话
            self.scanSession = scanSession
        }
        catch {
            
            //摄像头不可用
            ScanCodeTool.confirm("温馨提示", "摄像头不可用", self)
            return
        }
    }
    
    //开始扫描
    fileprivate func startScan() {
        
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        
        guard let scanSession = scanSession else { return }
        
        if !scanSession.isRunning {
            scanSession.startRunning()
        }
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation {
        
        let x : CGFloat =  scanPane.x / 2 * 3
        
        let startPoint = CGPoint(x: x, y: 1)
        let endPoint = CGPoint(x: x, y: scanPane.bounds.size.height - 2)
        
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
        self.scanPane.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        ScanCodeTool.playAlertSound("noticeMusic.caf")
        
        weak var weakSelf = self
        //扫完完成
        if metadataObjects.count > 0 {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                
                ScanCodeTool.confirm("扫描结果", resultObj.stringValue, self,handler: { (_) in
                    
                    //继续扫描
                    weakSelf?.startScan()
                })
            }
        }
    }
}
