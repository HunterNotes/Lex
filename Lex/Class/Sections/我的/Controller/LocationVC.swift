//
//  LocationVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/26.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class LocationVC: BaseViewController, SearchDelegate {
    
    @IBOutlet weak var topView      : UIView!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var searchBtn    : UIButton!
    
    var selectIndex                 : Int = 0
    var mapView                     : MAMapView!
    var gpsButton                   : UIButton!
    var hiddenSearch                : Bool = false
    var isEnlarge                   : Bool = false
    var lastContentOffset           : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.naBar)
        
        initMapView()
        registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }
    
    //MARK: 导航条相关
    lazy var naBar: PresentNaBarView = {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let bar : PresentNaBarView = PresentNaBarView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 64));
        bar.naBarItem.text = "位置"
        bar.backgroundColor = nav_color()
        bar.saveBtn.isEnabled = false
        bar.saveBtn.setTitle("确定", for: .normal)
        bar.cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        bar.saveBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return bar
    }()
    
    
    func cancel() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirm() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: 搜索框相关
    lazy var search: Search = {
        let se = Search.init(frame: UIScreen.main.bounds)
        se.searchField.placeholder = "搜索地址"
        se.delegate = self
        return se
    }()
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        self.hiddenSearch = true
        self.touchSearchAnimation()
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.search)
            self.search.animate()
        }
    }
    
    func touchSearchAnimation() {
        
        weak var weakSelf = self
        if self.hiddenSearch {
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn, animations: {
                
                weakSelf?.topView.snp.updateConstraints({ (make) in
                    make.left.equalTo(0)
                    make.top.equalTo(69)
                    make.size.equalTo(CGSize.init(width: app_width, height: 270))
                })
                weakSelf?.tableView.snp.updateConstraints({ (make) in
                    make.left.equalTo(0)
                    make.top.equalTo(339)
                    make.size.equalTo(CGSize.init(width: app_width, height: app_height - 339))
                })
                weakSelf?.searchBtn.isHidden = true
                
            }, completion: { (finish : Bool) in
                
            })
        }
        else {
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn, animations: {
                
                weakSelf?.topView.snp.updateConstraints({ (make) in
                    make.left.equalTo(0)
                    make.top.equalTo(109)
                    make.size.equalTo(CGSize.init(width: app_width, height: 270))
                })
                weakSelf?.tableView.snp.updateConstraints({ (make) in
                    make.left.equalTo(0)
                    make.top.equalTo(379)
                    make.size.equalTo(CGSize.init(width: app_width, height: app_height - 379))
                })
                weakSelf?.searchBtn.isHidden = false
                
            }, completion: { (finish : Bool) in
                
            })
        }
    }
    
    //MARK: SearchDelegate
    func hideSearchView(status : Bool) {
        
        self.hiddenSearch = false
        self.touchSearchAnimation()
        
        if status == true {
            self.search.removeFromSuperview()
        }
    }
    
    //MARK: 高德地图相关
    func makeGPSButtonView() -> UIButton! {
        
        let ret = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        ret.backgroundColor = UIColor.white
        ret.layer.cornerRadius = 4
        
        ret.setImage(UIImage.init(named: "gpsStat1"), for: UIControlState.normal)
        ret.addTarget(self, action: #selector(self.gpsAction), for: UIControlEvents.touchUpInside)
        
        return ret
    }
    
    func makeZoomPannelView() -> UIView {
        
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 98))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 49))
        incBtn.setImage(UIImage.init(named: "increase"), for: UIControlState.normal)
        incBtn.sizeToFit()
        incBtn.addTarget(self, action: #selector(self.zoomPlusAction), for: UIControlEvents.touchUpInside)
        
        let decBtn = UIButton.init(frame: CGRect.init(x: 0, y: 49, width: 53, height: 49))
        decBtn.setImage(UIImage.init(named: "decrease"), for: UIControlState.normal)
        decBtn.sizeToFit()
        decBtn.addTarget(self, action: #selector(self.zoomMinusAction), for: UIControlEvents.touchUpInside)
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.topView.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        mapView.showsUserLocation = true
        self.topView.addSubview(mapView)
        
        let zoomPannelView = self.makeZoomPannelView()
        zoomPannelView.center = CGPoint.init(x: self.topView.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.topView.bounds.size.height -  zoomPannelView.bounds.width/2 - 30)
        
        zoomPannelView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleLeftMargin]
        self.topView.addSubview(zoomPannelView)
        
        gpsButton = self.makeGPSButtonView()
        gpsButton.center = CGPoint.init(x: gpsButton.bounds.width / 2 + 10, y:self.topView.bounds.size.height -  gpsButton.bounds.width / 2 - 20)
        self.topView.addSubview(gpsButton)
        gpsButton.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleRightMargin]
    }
    
    func zoomPlusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom+1, animated: true)
    }
    
    func zoomMinusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom-1, animated: true)
    }
    
    func gpsAction() {
        if(self.mapView.userLocation.isUpdating && self.mapView.userLocation.location != nil) {
            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
            self.gpsButton.isSelected = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        weak var weakSelf = self
        let contentOffsety : CGFloat = scrollView.contentOffset.y
        if contentOffsety < 0 {
            var rect : CGRect = self.topView.frame
            rect.size.height = self.topView.height - contentOffsety
            rect.origin.y = 0
            self.topView.frame = rect
        }
        else {
            
            var rect : CGRect = self.topView.frame
            rect.size.height = self.topView.height
            rect.origin.y = -contentOffsety
            self.topView.frame = rect
            
        }

        
//        if (self.lastContentOffset > contentOffsety) {
//            
//            
////            self.scaleAnimation(flag: 0)
//                        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
//                            weakSelf?.topView.transform = CGAffineTransform.init(scaleX: 1, y: 0.5)
//                            weakSelf?.tableView.transform = CGAffineTransform.init(scaleX: 1, y: (app_height - 244) / (app_height - 379))
//            
////                            weakSelf?.topView.snp.updateConstraints({ (make) in
////                                make.left.equalTo(0)
////                                make.top.equalTo(109)
////                                make.size.equalTo(CGSize.init(width: app_width, height: 135))
////                            })
////                            weakSelf?.tableView.snp.updateConstraints({ (make) in
////                                make.left.equalTo(0)
////                                make.top.equalTo(244)
////                                make.size.equalTo(CGSize.init(width: app_width, height: app_height - 244))
////                            })
//                        }, completion: { (finish : Bool) in
//            
//                        })
//        }
//        else {
//            
////            self.scaleAnimation(flag: 1)
//            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
//                weakSelf?.topView.transform = CGAffineTransform.init(scaleX: 1, y: 2)
//                weakSelf?.tableView.transform = CGAffineTransform.init(scaleX: 1, y: (app_height - 379) / (app_height - 244))
//                
////                weakSelf?.topView.snp.updateConstraints({ (make) in
////                    make.left.equalTo(0)
////                    make.top.equalTo(109)
////                    make.size.equalTo(CGSize.init(width: app_width, height: 270))
////                })
////                weakSelf?.tableView.snp.updateConstraints({ (make) in
////                    make.left.equalTo(0)
////                    make.top.equalTo(379)
////                    make.size.equalTo(CGSize.init(width: app_width, height: app_height - 379))
////                })
//                
//            }, completion: { (finish : Bool) in
//                
//            })
//        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.lastContentOffset = scrollView.contentOffset.y;
//    }
    
    //MARK: 放大动画
    func scaleAnimation(flag : Int) {
        
        weak var weakSelf = self
        
        // 设定为缩放
        let animation : CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale.y")
        animation.duration = 1.5
        animation.repeatCount = 0
        
        // 动画结束时执行逆动画
//        animation.autoreverses = true
        
        let animat : CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale.y")
        animat.duration = 1.5
        animat.repeatCount = 0
        
        // 动画结束时执行逆动画
        animat.autoreverses = true
        
        if flag == 0 {
            
            weakSelf?.topView.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(109)
                make.size.equalTo(CGSize.init(width: app_width, height: 135))
            })
            weakSelf?.tableView.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(244)
                make.size.equalTo(CGSize.init(width: app_width, height: app_height - 244))
            })
            
            // 缩放倍数
            animation.fromValue = NSNumber.init(value: 1)
            animation.toValue = NSNumber.init(value: 0.5)
            
            // 缩放倍数
            animat.fromValue = NSNumber.init(value: 1)
            
            let num : Float = Float((app_height - 244) / (app_height - 379))
            animat.toValue = NSNumber.init(value: num)
        }
        else {
            
            weakSelf?.topView.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(109)
                make.size.equalTo(CGSize.init(width: app_width, height: 270))
            })
            weakSelf?.tableView.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(379)
                make.size.equalTo(CGSize.init(width: app_width, height: app_height - 379))
            })
            
            // 缩放倍数
            animation.fromValue = NSNumber.init(value: 1)
            animation.toValue = NSNumber.init(value: 2)
            
            // 缩放倍数
            animat.fromValue = NSNumber.init(value: 1)
            
            let num : Float = Float((app_height - 379) / (app_height - 244))
            animat.toValue = NSNumber.init(value: num)
        }
        
        self.topView.layer.add(animation, forKey: "scale-layer")
        self.tableView.layer.add(animat, forKey: "scale-layer1")
    }
    
    //MARK: 缩小动画
    func narrowedAnimation() {
        
    }
}

//MARK: MAMapViewDelegate
extension LocationVC : MAMapViewDelegate {
    
    //地图开始加载
    func mapViewWillStartLoadingMap(_ mapView: MAMapView!) {
        
    }
    
    //地图加成功
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        
    }
    
    //地图区域改变完成
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        
    }
    
    //地图将要发生移动
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        
    }
    
    //地图移动结束后
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
    }
    
    //地图将要发生缩放
    func mapView(_ mapView: MAMapView!, mapWillZoomByUser wasUserAction: Bool) {
        
    }
    
    //地图缩放结束
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        
    }
}

//MARK: UITableViewDataSource && UITableViewDelegate
extension LocationVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: Int = (indexPath as NSIndexPath).row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if row == selectIndex {
            cell.mark.isHidden = false
        }
        else {
            cell.mark.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: Int = (indexPath as NSIndexPath).row
        self.selectIndex = row
        tableView.reloadData()
    }
    
}
