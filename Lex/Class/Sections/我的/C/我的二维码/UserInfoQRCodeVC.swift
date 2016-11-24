//
//  UserInfoQRCodeVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/16.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD
import CoreLocation

class UserInfoQRCodeVC: UIViewController {
    
    @IBOutlet weak var userImgView      : UIImageView!
    @IBOutlet weak var userNameLab      : UILabel!
    @IBOutlet weak var genderImgView    : UIImageView!
    @IBOutlet weak var locationLab      : UILabel!
    @IBOutlet weak var qrImgView        : UIImageView!
    
    var pushFlag                        : Int?
    var sqlManager                      : SQLiteManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的二维码"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_more"), style: .plain, target: self, action: #selector(edit))
        
        self.initData()
        self.addLongpress()
        
        sqlManager = SQLiteManager.defaultManager()
        //        self.getLocation()
    }
    
    func initData () {
        
        let manager : CCSingleton = CCSingleton.sharedUser()
        let location : String = manager.state_Format! + " " + manager.city_Format!
        
        self.userImgView.layer.cornerRadius = 10
        self.userImgView.layer.borderWidth = 0.5
        self.userImgView.layer.borderColor = UIColor.darkGray.cgColor
        self.userImgView.image = sqlManager.getUserImageFromSQLite()
        self.userNameLab.text = USERNAME
        self.locationLab.text = location
        self.qrImgView.image = self.creatQRCodeImage("https://github.com/HunterNotes/Swift_Debug")
    }
    
    func getLocation () {
        
        if(CLLocationManager.authorizationStatus() != .denied) {
            print("应用拥有定位权限")
        }
        else {
            let aleat = UIAlertController(title: "打开定位开关", message:"权限被禁止，请在\"设置-隐私-定位服务\"中进行授权", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
                let url = URL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            aleat.addAction(tempAction)
            aleat.addAction(callAction)
            self.present(aleat, animated: true, completion: nil)
        }
    }
    
    func addLongpress() {
        
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(edit))
        longPress.numberOfTouchesRequired = 1
        self.qrImgView.addGestureRecognizer(longPress)
    }
    
    //MARK: 编辑二维码
    func edit() {
        
        let optionMenu = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction.init(title: "保存图片", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.PhotoLibraryPermissions() == false {
                SVProgressHUD.showInfo(withStatus: "您尚未开启相册访问权限")
                return
            }
            self.save()
            print("File Saved")
        })
        optionMenu.addAction(saveAction)
        
        if self.pushFlag == 0 {
            let scanAction = UIAlertAction.init(title: "扫描二维码", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if self.cameraPermissions() == false {
                    
                    SVProgressHUD.showError(withStatus: "您尚未开启相机访问权限")
                    return
                }
                
                let vc = ScanCodeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                //            self.starScan()
                print("File camera")
            })
            optionMenu.addAction(scanAction)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: 调用照片方法
    func photo() {
        
        let pick : UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
    }
    
    //MARK: 保存图片到相册
    func save() {
        
        UIImageWriteToSavedPhotosAlbum(self.qrImgView.image!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: 判断相机权限
    func cameraPermissions() -> Bool {
        
        let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: 判断相册权限
    func PhotoLibraryPermissions() -> Bool {
        
        let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: 保存图片提示
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            SVProgressHUD.show(UIImage.init(named: "icon_close"), status: "保存失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
        else {
            SVProgressHUD.show(UIImage.init(named: "success"), status: "已保存到系统相册")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
    
    fileprivate func creatQRCodeImage(_ text: String?) -> UIImage {
        
        //        var qrImg : UIImage? = nil
        //        DispatchQueue.global().async {
        
        //            DispatchQueue.main.async(execute: {
        //                let image = text?.generateQRCodeWithLogo(logo:userImg)
        //                qrImg = image
        //            })
        //        }
        return text!.generateQRCodeWithLogo(self.userImgView.image)
    }
    
    //MARK: 传进去字符串,生成二维码图片
    //    private func creatQRCodeImage(text: String) -> UIImage {
    //
    //        //创建滤镜
    //        let filter = CIFilter(name: "CIQRCodeGenerator")
    //
    //        //还原滤镜的默认属性
    //        filter?.setDefaults()
    //
    //        //设置需要生成二维码的数据
    //        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
    //
    //        //从滤镜中取出生成的图片
    //        let ciImage = filter?.outputImage
    //
    //        // 接着利用KVO设置二维码的文字
    //        filter?.setValue(text.data(using: String.Encoding.utf8, allowLossyConversion: false), forKey: "inputMessage")
    //
    //        // 最后获取滤镜生成的二维码高清图片
    //        let bgImage = UIImage(ciImage:(ciImage!.applying(CGAffineTransform(scaleX: 10, y: 10))))
    //
    //        //合成图片(把二维码和头像合并)
    //        let newImage = creatImage(bgImage: bgImage, iconImage: userImg!)
    //
    //        //返回生成好的二维码
    //        return newImage
    //    }
    
    //MARK: 根据背景图片和头像合成头像二维码
    //    private func creatImage(bgImage: UIImage, iconImage:UIImage) -> UIImage {
    //
    //        //开启图片上下文
    //        UIGraphicsBeginImageContext(bgImage.size)
    //
    //        //绘制背景图片
    //        bgImage.draw(in: CGRect(origin: CGPoint.init(x: 0, y: 0), size: bgImage.size))
    //
    //        //绘制头像
    //        let width: CGFloat = 60
    //        let height: CGFloat = width
    //
    //        let x = (bgImage.size.width - width) * 0.5
    //        let y = (bgImage.size.height - height) * 0.5
    //        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
    //
    //        //取出绘制好的图片
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        //关闭上下文
    //        UIGraphicsEndImageContext()
    //
    //        return newImage!
    //    }
    
    
    // MARK: - 1. 懒加载: 会话,输入设备,输出设备,预览图层
    //会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    //拿到输入设备
    fileprivate lazy var deviceInput: AVCaptureDeviceInput? = {
        
        //获取摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }
        catch {
            print(error)
            return nil
        }
    }()
    
    //拿到输出设备
    fileprivate lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer?.frame = UIScreen.main.bounds
        return layer!
    }()
    
    //MARK: - 2. 扫描二维码
    func starScan() {
        
        //先判断是否能将设备添加到回话中
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //判断是否能够将输出添加到回话中
        if !session .canAddOutput(output) {
            return
        }
        
        //将输入和输出添加到回话中
        session.addInput(deviceInput)
        session.addOutput(output)
        
        //设置输入能够解析的数据类型
        //设置能解析的数据类型,一定要在输出对象添加到会员之后设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //设置输出对象的代理,只要解析成功,就会通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //告诉session开始扫描
        session.startRunning()
    }
}



//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension UserInfoQRCodeVC : AVCaptureMetadataOutputObjectsDelegate {
    
    //只要解析到数据就会调用
    fileprivate func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //获取扫描结果
        //注意是: stringValue
        print(metadataObjects.last?.stringValue ?? "")
    }
}


//MARK: - UIImagePickerControllerDelegate UINavigationControllerDelegate
extension UserInfoQRCodeVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
