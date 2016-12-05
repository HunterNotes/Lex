//
//  ScanCodeViewController.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/18.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

private let scanAnimationDuration = 3.0 //扫描时长

class ScanCodeViewController: UIViewController {
    
    var lightOn       : Bool = false //闪光灯
    var scanSession   : AVCaptureSession?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "二维码扫描"
        _ = self.scanCodeView
        setupScanSession()
    }
    
    lazy var scanCodeView : ScanCodeView = {
        
        var scanCode : ScanCodeView = ScanCodeView()
        scanCode.newViews()
        
        scanCode.tabBarView.photoBtn.addTarget(self, action: #selector(photo), for: .touchUpInside)
        scanCode.tabBarView.lightBtn.addTarget(self, action: #selector(light), for: .touchUpInside)
        scanCode.tabBarView.myQRCodeBtn.addTarget(self, action: #selector(myQRCode), for: .touchUpInside)
        
        self.view.addSubview(scanCode)
        weak var weakSelf : ScanCodeViewController? = self
        scanCode.snp.makeConstraints { (make) -> Void in
            make.top.equalTo((weakSelf?.view)!).offset(0)
            make.left.equalTo((weakSelf?.view)!).offset(0)
            make.size.equalTo(CGSize.init(width: app_width, height: app_height))
        }
        return scanCode
    }()
    
    //MARK: Action - 相册
    func photo(sender : UIButton) {
        
        weak var weakSelf : ScanCodeViewController? = self
        //[weak self]
        ScanCodeTool.shareTool().choosePicture(self, true, .photoLibrary) {[weak self] (image) in
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
        
        let vc = UserInfoQRCodeVC()
        vc.pushFlag = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        startScan()
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
            
            weak var weakSelf : ScanCodeViewController! = self
            
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
            ScanCodeTool.confirm("温馨提示", "摄像头不可用", self)
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
        let endPoint = CGPoint(x: (self.scanCodeView.scanLine.center.x), y: (self.scanCodeView.scanPane.bounds.size.height) - 2)
        
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
                ScanCodeTool.confirm("温馨提示", "闪光灯不可用", self)
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
extension ScanCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //停止扫描
        self.scanCodeView.scanLine.layer.removeAllAnimations()
        self.scanSession!.stopRunning()
        
        //播放声音
        ScanCodeTool.playAlertSound("noticeMusic.caf")
        
        weak var weakSelf : ScanCodeViewController? = self
        
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
