//
//  CustomCameraViC.swift
//  Lex
//
//  Created by nbcb on 2017/3/14.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import CoreImage

class CustomCameraViC: BaseViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var cameraView: UIView!      //相机显示
    @IBOutlet weak var focusView: UIImageView!  //聚焦图片
    @IBOutlet weak var picListCollectionView: PicListCollectionView!//展示列表
    fileprivate lazy var imgView : UIImageView = UIImageView()
    
    override func viewDidLoad() {
        
        initAVCapture()
        
        weak var weakSelf = self
        self.picListCollectionView.selPicBlock = { (_ picture : UIImage) -> Void in
            
            weakSelf?.showImageView(picture)
        }
    }
    
    func showImageView(_ image : UIImage) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissImageView(_:)))
        
        let window : UIWindow = UIApplication.shared.keyWindow!
        self.imgView.frame = window.frame
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tapGestureRecognizer)
        
        self.imgView.image = image
        window.addSubview(self.imgView)
        
        self.imgView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
        
        UIView.animate(withDuration: 0.5, delay:0.01,
                       options:UIViewAnimationOptions.curveEaseIn, animations:
            { ()-> Void in
                self.imgView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                
        }, completion:{ (finished:Bool) -> Void in
            
            UIView.animate(withDuration: 0.08, animations:{
                ()-> Void in
                self.imgView.layer.setAffineTransform(CGAffineTransform.identity)
            })
        })
    }
    
    @objc fileprivate func dismissImageView(_ gesture : UITapGestureRecognizer) {
        
        self.imgView.removeFromSuperview()
    }
    
    //拍照的图片
    fileprivate lazy var imgArr: [UIImage] = {
        
        let arr : Array = [UIImage]()
        return arr
    }()
    
    func initAVCapture() {
        
        //启动照相机
        DCCameraAlbum.shareCamera().start(view: cameraView, frame: CGRect(x: 0, y: 0, width: app_width, height: self.view.height - 44 - 170))
        
        //设置聚焦图片
        DCCameraAlbum.shareCamera().focusView = focusView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.topBar.alpha = 0.65
    }
    
    //闪关灯
    @IBAction func switchLight(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        sender.setImage(UIImage.init(named: "flash"), for: .normal)
        sender.setImage(UIImage.init(named: "flash-on"), for: .selected)
    }
    
    //设置
    @IBAction func setting(_ sender: UIButton) {
        
    }
    
    //镜头方向
    @IBAction func cameraType(_ sender: UIButton) {
        DCCameraAlbum.shareCamera().beforeAfterCamera()
        
    }
    
    //拍照
    @IBAction func photo(_ sender: UIButton) {
        
        DCCameraAlbum.shareCamera().takePhoto { [unowned self] (image) in
            self.imgArr.append(image)
            self.picListCollectionView.imgArr = self.imgArr
        }
    }
    
    //相册
    @IBAction func album(_ sender: UIButton) {
        
//        let vc = UIStoryboard.init(name: "PageNavigation", bundle: nil).instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
//        vc.imgArr = self.imgArr
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
