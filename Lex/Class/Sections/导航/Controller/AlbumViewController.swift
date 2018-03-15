//
//  AlbumViewController.swift
//  Lex
//
//  Created by nbcb on 2017/3/17.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var albumCollectionView: AlbumCollectionView!
    fileprivate lazy var imgView : UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navTitle = "相册"
        
        self.albumCollectionView.imgArr = self.imgArr
        
        weak var weakSelf = self
        self.albumCollectionView.showPicBlock = { (_ picture : UIImage) -> Void in
            
            weakSelf?.showImageView(picture)
        }
    }
    
    var imgArr = [UIImage]() {
        
        didSet {
//            self.albumCollectionView.reloadData()
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
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
