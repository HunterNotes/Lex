//
//  UserInfoQRCodeVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/16.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

class UserInfoQRCodeVC: UIViewController {
    
    @IBOutlet weak var userImgView      : UIImageView!
    @IBOutlet weak var userNameLab      : UILabel!
    //    @IBOutlet weak var genderImgView    : UIImageView!
    
    @IBOutlet weak var locationLab      : UILabel!
    @IBOutlet weak var qrImgView        : UIImageView!
    
    var pushFlag                        : Int? = nil  //扫描二维码页面跳转
    var sqlManager                      : SQLiteManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的二维码"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_more"), style: .plain, target: self, action: #selector(edit))
        
        self.getDisplayInfo()
        self.addTapGesture()
    }
    
    func getDisplayInfo() {
        
        sqlManager = SQLiteManager.defaultManager()
        let manager : CCSingleton = CCSingleton.sharedUser()
        let location : String = manager.state_Format! + " " + manager.city_Format!
        
        let image = sqlManager.getImageFromSQLite(USER_IMGNAME)
        
        //绘制圆角UIImage
        self.userImgView.image = image.getRoundRectImage(self.userImgView.size.width, 5, 1, UIColor.gray)
        
        //从本地数据库获取头像
        self.userNameLab.text = USERNAME
        self.locationLab.text = location
        
        self.qrImgView.image = sqlManager.getImageFromSQLite(USER_QRIMGNAME)
        //        self.creatQRCodeImage(QRTEXT)
    }
    
    //MARK: - 获取定位权限
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
    
    func addTapGesture() {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(edit))
        self.qrImgView.addGestureRecognizer(tap)
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
                
                let vc = ScanCodeVC()
                UIView.transition(from: self.view, to: vc.view, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, completion: { (finish : Bool) in
                    //动画
                })
                self.navigationController?.pushViewController(vc, animated: true)
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
    
    //MARK: - 保存图片提示
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
