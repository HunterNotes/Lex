//
//  UserPhotoVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/14.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD
//import SQLite

enum EditImgType : Int {
    
    case none = 0
    case changed
}

class UserPhotoVC: BaseViewController {
    
    @IBOutlet weak var userImgView  : UIImageView!
    
    var imgType                 : EditImgType = .none
    
    var manager : SQLiteManager!
    // 数据库文件
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "个人头像"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_more"), style: .plain, target: self, action: #selector(editPhoto))
        self.addLongpress()
        
        manager = SQLiteManager.defaultManager()
        self.userImgView.image = manager.getImageFromSQLite(USER_IMGNAME)
        
        imgType = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if imgType == .changed {
            
            SVProgressHUD.show(UIImage.init(named: "success"), status: "上传成功")
        }
    }
    
    fileprivate func addLongpress() {
        
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(editPhoto))
        longPress.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(longPress)
    }
    
    //MARK: - 编辑图片
    func editPhoto() {
        
        let optionMenu = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "拍照", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.cameraPermissions() == false {
                
                SVProgressHUD.showError(withStatus: "您尚未开启相机访问权限")
                return
            }
            self.camera()
            print("File camera")
        })
        let photoAction = UIAlertAction.init(title: "从相册选择", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.PhotoLibraryPermissions() == false {
                SVProgressHUD.showInfo(withStatus: "您尚未开启相册访问权限")
                return
            }
            self.photo()
            print("File photo")
        })
        let saveAction = UIAlertAction.init(title: "保存图片", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.PhotoLibraryPermissions() == false {
                SVProgressHUD.showInfo(withStatus: "您尚未开启相册访问权限")
                return
            }
            self.save()
            print("File Saved")
        })
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - 调用相机
    fileprivate func camera() {
        
        let pick : UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pick, animated: true, completion: nil)
    }
    
    //MARK: - 调用照片
    fileprivate func photo() {
        
        let pick : UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
    }
    
    //MARK: - 判断相机权限
    fileprivate func cameraPermissions() -> Bool {
        
        let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: - 判断相册权限
    fileprivate func PhotoLibraryPermissions() -> Bool {
        
        let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: - 保存图片到相册
    fileprivate func save() {
        
        UIImageWriteToSavedPhotosAlbum(self.userImgView.image!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        DispatchQueue.global().async {
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
    
    //MARK: - 保存图片到数据库
    fileprivate func saveImageToSQL(_ image : UIImage) {
        
        weak var weakSelf = self
        
        DispatchQueue.global().async {
            
            //获取头像并转为base64字符串
            let imgStr : String = SavaImgHelper.imageToBase64String(image)!
            
            //生成二维码
            let qrImg  : UIImage = QRTEXT.generateQRCodeWithLogo(image)
            
            //二维码图片转为base64字符串
            let qrStr  : String = SavaImgHelper.imageToBase64String(qrImg)!
            
            if qrStr == "--" {
                
                let qrImgSize : Int = qrStr.characters.count / 1024
                print("二维码大小为", qrImgSize, "KB");
            }
            
            //先清空表
            weakSelf?.manager.delete(TABLENAME)
            
            //插入数据
            weakSelf?.manager.insert(TABLENAME, USERNAME, imgStr, qrStr)
        }
        
        //主页保存头像block
        let saveImageHelper : SaveUserImageHelper = SaveUserImageHelper()
        saveImageHelper.saveImage(saveImageBlock!, msg: "saveImage")
        
        //上个页面刷新头像通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userImgChanged"), object: self, userInfo: ["userImgChanged": "userImgChanged"])
    }
}

extension UserPhotoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //再次赋值，防止图片显示状态未更新
        self.userImgView.image = image
        saveImageToSQL(image!)
        imgType = .changed
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
