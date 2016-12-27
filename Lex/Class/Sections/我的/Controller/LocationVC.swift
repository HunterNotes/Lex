//
//  LocationVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/26.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class LocationVC: BaseViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectIndex : Int = 0
    var mapView: MAMapView!
    var gpsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.view.addSubview(self.naBar)
        self.naBar.naBarItem.text = "位置"
        
        initMapView()
        registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }
    
    //MARK: 导航条相关
    lazy var naBar: PresentNaBarView = {
        
        let bar : PresentNaBarView = PresentNaBarView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 64));
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
    
    //MARK: <# 根据背景图片和头像合成头像二维码#>
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

//MARK: UISearchBarDelegate
extension LocationVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("[ViewController searchBar] searchText: \(searchText)")
        
    }
    
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 搜索内容置空
        
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
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: Int = (indexPath as NSIndexPath).row
        self.selectIndex = row
        tableView.reloadData()
    }
}
