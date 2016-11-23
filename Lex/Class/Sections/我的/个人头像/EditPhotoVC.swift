//
//  EditPhotoVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/14.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SQLite
import SVProgressHUD

enum EditImgType : Int {
    
    case none = 0
    case changed
}

class EditPhotoVC: UIViewController {
    
    @IBOutlet weak var userImgView  : UIImageView!
    
    var imgType                 : EditImgType = .none
    
    // 数据库文件
    var db: Connection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "个人头像"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_more"), style: .plain, target: self, action: #selector(editPhoto))
        self.addLongpress()
        
        self.userImgView.image = userImg
        imgType = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if imgType == .changed {
            
            let userDefault = UserDefaults.standard
            userDefault.setValue(userImg?.description, forKey: saveImgFlag)
            
            
            SVProgressHUD.show(UIImage.init(named: "success"), status: "上传成功")
            
        }
    }
    
    fileprivate func addLongpress() {
        
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(editPhoto))
        longPress.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(longPress)
    }
    
    func editPhoto() {
        
        let optionMenu = UIAlertController.init(title: nil, message: "编辑头像", preferredStyle: .actionSheet)
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
    
    //调用照相机方法
    fileprivate func camera() {
        
        let pick : UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pick, animated: true, completion: nil)
    }
    
    //调用照片方法
    fileprivate func photo() {
        
        let pick : UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
    }
    
    //保存图片到相册
    fileprivate func save() {
        
        UIImageWriteToSavedPhotosAlbum(self.userImgView.image!, self, #selector(saveImage( image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //判断相机权限
    fileprivate func cameraPermissions() -> Bool {
        
        let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }
        else {
            return true
        }
    }
    
    //判断相册权限
    fileprivate func PhotoLibraryPermissions() -> Bool {
        
        let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            return false
        }
        else {
            return true
        }
    }
    
    //保存图片到相册
    @objc fileprivate func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            SVProgressHUD.show(UIImage.init(named: "icon_close"), status: "保存失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
        else {
            SVProgressHUD.show(UIImage.init(named: "success"), status: "已保存到系统相册")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
    }
    
    //MARK: - 保存图片到数据库
//    fileprivate func saveImageToSQL(_ img : UIImage) {
//        
//        //能压缩图片质量 代替 UIImagePNGRepresentation
//        UIImageJPEGRepresentation(img, 0.5)
//        
//        let imgData : Data = UIImagePNGRepresentation(img)!
//        
//        
//        // 把 data 转成 Base64 的 string
//        let string = imgData.base64EncodedStringWithOptions(.allZeros)
//        
//        
//    }
    
    // 文件路径
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    // 获取链接（不存在文件，则自动创建）
    fileprivate func GetConnection() ->Int {
        
        do {
            db =  try Connection("\(path)/db.sqlite")
            
        }
        catch _ {
            return 0
        }
        return 1
    }
    
    
    // 创建表
    fileprivate func CreateTable() {
        
        print("\(path)")
        
        GetConnection();
        let USERINFO = Table("USERINFO")
        let id = Expression<Int64>("id")
        let username = Expression<String?>("username")
        let password = Expression<String?>("password")
        
        do {
            try db!.run(USERINFO.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(username, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
                t.column(password, unique: true) })
        }
        catch _{
            
        }
    }
}

extension EditPhotoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        userImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //再次赋值，防止图片显示状态未更新
        self.userImgView.image = userImg
        imgType = .changed
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
