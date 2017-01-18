//
//  LocationVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/26.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class LocationVC: BaseViewController, LocationSearchDelegate, AMapSearchDelegate {
    
    @IBOutlet weak var searchBtn    : UIButton!
    
    var selectIndex                 : Int = 0
    var hiddenSearch                : Bool = false
    var isFirstLoading              : Bool = true       //是否是第一次定位
    
    var displayMap                  : Bool = true  //地图状态：是否展开
    
    let minTableView_h              : CGFloat = app_height - 379
    let maxTableView_h              : CGFloat = app_height - 244
    let tableView_y                 : CGFloat = 379.0
    let minMap_h                    : CGFloat = 135.0
    let maxMap_h                    : CGFloat = 270.0
    let headerYOffSet               : CGFloat = 109.0
    let default_Y_tableView         : CGFloat = 244.0
    var contentOffsetY              : CGFloat = 0
    
    var dataArray                   : Array<AMapPOI> = []
    var locationBlock               : ReturnLocationBlock?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.view.addSubview(self.naBar)
        
        self.setupMapView()
        self.initSearchs()
        self.setupTableView()
        self.registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }
    
    func setupTableView() {
        
        self.view.addSubview(self.tableView)
        self.tableView.addSubview(self.activity)
        
        weak var weakSelf = self
        self.activity.snp.makeConstraints { (make) in
            make.centerX.equalTo((weakSelf?.tableView.centerX)!)
            make.top.equalTo(10)
            make.size.equalTo(CGSize.init(width: 37, height: 37))
        }
    }
    
    lazy var activity : UIActivityIndicatorView = {
        
        let activity : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activity.isHidden = true
        return activity
    }()
    
    //MARK: 导航条相关
    lazy var naBar: PresentNaBarView = {
        
        let bar : PresentNaBarView = PresentNaBarView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 64))
        bar.naBarItem.text = "位置"
        bar.backgroundColor = nav_color()
        bar.saveBtn.setTitle("确定", for: .normal)
        bar.cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        bar.saveBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return bar
    }()
    
    func cancel() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirm() {
        
        let mapPOI : AMapPOI = (self.dataArray[selectIndex])
        
        let manager : ReturnLocationHelper = ReturnLocationHelper.sharedManager()
        if ((manager.locationBlock) != nil) {
            
            manager.returnLocation(manager.locationBlock!, true, mapPOI)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: 搜索框相关
    
    lazy var search: LocationSearch = {
        
        let se = LocationSearch.init(frame: UIScreen.main.bounds)
        se.searchField.placeholder = "搜索地址"
        se.delegate = self
        return se
    }()
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if self.mapView.height < self.maxMap_h {
            self.displayMap = false
        }
        else {
            self.displayMap = true
        }
        
        self.hiddenSearch = true
        self.touchSearchAnimation()
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.search)
            self.search.animate()
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        }
    }
    
    func touchSearchAnimation() {
        
        weak var weakSelf = self
        if self.hiddenSearch {
            
            UIView.animate(withDuration: 0.25, delay: 0.01, options: .curveEaseIn, animations: {
                
                if (weakSelf?.displayMap)! {
                    weakSelf?.mapView.frame = CGRect.init(x: 0, y: 69, width: app_width, height: (weakSelf?.maxMap_h)!)
                    weakSelf?.tableView.frame = CGRect.init(x: 0, y: 339, width: app_width, height: app_height - 339)
                }
                else {
                    let originY : CGFloat = 339 - (weakSelf?.minMap_h)!
                    let height : CGFloat = app_height - 339 + (weakSelf?.minMap_h)!
                    
                    weakSelf?.mapView.frame = CGRect.init(x: 0, y: 69, width: app_width, height: (weakSelf?.minMap_h)!)
                    weakSelf?.tableView.frame = CGRect.init(x: 0, y: originY, width: app_width, height: height)
                }
                weakSelf?.searchBtn.isHidden = true
                
            }, completion: { (finish : Bool) in
                
            })
        }
        else {
            
            UIView.animate(withDuration: 0.25, delay: 0.01, options: .curveEaseIn, animations: {
                
                if (weakSelf?.displayMap)! {
                    
                    weakSelf?.mapView.frame = CGRect.init(x: 0, y: 109, width: app_width, height: (weakSelf?.maxMap_h)!)
                    weakSelf?.tableView.frame = CGRect.init(x: 0, y: 379, width: app_width, height: app_height - 379)
                }
                else {
                    let originY : CGFloat = 379 - (weakSelf?.minMap_h)!
                    let height : CGFloat = app_height - 379 + (weakSelf?.minMap_h)!
                    
                    weakSelf?.mapView.frame = CGRect.init(x: 0, y: 109, width: app_width, height: (weakSelf?.minMap_h)!)
                    weakSelf?.tableView.frame = CGRect.init(x: 0, y: originY, width: app_width, height: height)
                }
                weakSelf?.searchBtn.isHidden = false
                
            }, completion: { (finish : Bool) in
                
            })
        }
    }
    
    //MARK: LocationSearchDelegate
    func hideSearchView(status : Bool) {
        
        self.hiddenSearch = false
        self.touchSearchAnimation()
        
        if status == true {
            
            self.search.removeFromSuperview()
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(CCSingleton.sharedUser().latitude, CCSingleton.sharedUser().longitude)
        }
    }
    
    lazy var tableView : UITableView = {
        
        let tab : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: self.tableView_y, width: app_width, height: self.minTableView_h), style: .grouped)
        tab.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 1.0))
        tab.tableHeaderView?.backgroundColor = globalBGColor()
        tab.tableFooterView = UIView()
        tab.dataSource = self
        tab.delegate = self
        return tab
    }()
    
    //MARK: 高德地图相关
    lazy var mapView : MAMapView = {
        
        let map : MAMapView = MAMapView(frame: CGRect.init(x: 0, y: 109, width: app_width, height: self.maxMap_h))
        map.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        map.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        map.showsUserLocation = true
        map.touchPOIEnabled = true
        map.pausesLocationUpdatesAutomatically = true
        
        //跟踪用户
        map.userTrackingMode = .follow
        
        //最小更新距离
        map.distanceFilter = 1
        
        //设置比例尺缩放级别
        map.zoomLevel = 15.5
        map.centerCoordinate = CLLocationCoordinate2DMake(CCSingleton.sharedUser().latitude, CCSingleton.sharedUser().longitude)
        map.delegate = self
        
        return map
    }()
    
    lazy var pin : UIImageView = {
        
        let pin : UIImageView = UIImageView.init(image: UIImage.init(named: "redPin_lift"))
        pin.frame = CGRect.init(x: (self.mapView.width - (pin.image?.size.width)!) / 2.0, y: (self.mapView.height - (pin.image?.size.height)!) / 2.0, width: (pin.image?.size.width)!, height: (pin.image?.size.height)!)
        return pin
    }()
    
    lazy var gpsButton : UIButton = {
        
        let rect : CGRect = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        let button = UIButton.init(frame: rect)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 4
        button.setImage(UIImage.init(named: "gpsStat1"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(LocationVC.gpsAction), for: UIControlEvents.touchUpInside)
        button.center = CGPoint.init(x: button.bounds.width / 2 + 10, y: self.mapView.bounds.size.height -  button.bounds.width / 2 - 20)
        button.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleRightMargin]
        return button
    }()
    
    lazy var makeZoomPannelView : UIView = {
        
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 109, width: app_width, height: self.maxMap_h))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: app_width - 58, y: 49, width: 53, height: 49))
        incBtn.setImage(UIImage.init(named: "increase"), for: UIControlState.normal)
        incBtn.sizeToFit()
        incBtn.addTarget(self, action: #selector(LocationVC.zoomPlusAction), for: UIControlEvents.touchUpInside)
        
        let decBtn = UIButton.init(frame: CGRect.init(x: app_width - 58, y: 98, width: 53, height: 49))
        decBtn.setImage(UIImage.init(named: "decrease"), for: UIControlState.normal)
        decBtn.sizeToFit()
        decBtn.addTarget(self, action: #selector(LocationVC.zoomMinusAction), for: UIControlEvents.touchUpInside)
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }()
    
    func setupMapView() {
        
        self.view.addSubview(self.mapView)
        let zoomPannelView = self.makeZoomPannelView
        zoomPannelView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleLeftMargin]
        self.mapView.addSubview(self.makeZoomPannelView)
        self.mapView.addSubview(self.gpsButton)
        self.mapView.addSubview(self.pin)
        self.pin.center = CGPoint.init(x: self.mapView.center.x, y: self.mapView.center.y - self.pin.height / 2.0 * 3)
        
    }
    
    func zoomPlusAction() {
        
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom + 1, animated: true)
    }
    
    func zoomMinusAction() {
        
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom - 1, animated: true)
    }
    
    func gpsAction() {
        
        self.isFirstLoading = false
        
        if (self.mapView.userLocation.isUpdating && self.mapView.userLocation.location != nil) {
            
            //设置当前位置为地图中心的位置
            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
            self.gpsButton.isSelected = true
        }
    }
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    //MARK: 搜索周边
    lazy var mapSearch : AMapSearchAPI = {
        
        let mapSearch : AMapSearchAPI = AMapSearchAPI()
        mapSearch.delegate = self
        return mapSearch
    }()
    
    lazy var mapRequest : AMapPOIAroundSearchRequest = {
        
        let request : AMapPOIAroundSearchRequest = AMapPOIAroundSearchRequest()
        request.types = "风景名胜|商务住宅|政府机构及社会团体|地名地址信息"
        request.sortrule = 0
        request.requireExtension = true
        return request
    }()
    
    func initSearchs() {
        
        self.mapRequest.location = AMapGeoPoint.location(withLatitude: CGFloat(CCSingleton.sharedUser().latitude), longitude: CGFloat(CCSingleton.sharedUser().longitude))
        self.mapSearch.aMapPOIAroundSearch(self.mapRequest) //搜索请求
    }
    
    //MARK: AMapSearchDelegate
    
    //逆地理编码查询回调函数
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        var str : NSString = response.regeocode.addressComponent.city as NSString // addressComponent包含用户当前地址
        if str.length == 0 {
            str = response.regeocode.addressComponent.province as NSString
        }
        
        self.mapView.userLocation.title = str as String
        self.mapView.userLocation.subtitle = response.regeocode.formattedAddress
    }
    
    //POI查询回调函数
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.pois.count == 0 {
            return
        }
        
        self.dataArray = response.pois as Array
        self.activity.stopAnimating()
        self.activity.isHidden = true
        self.tableView.reloadData()
    }
    
    //MARK: 展开地图
    func openShutter() {
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, delay: 0.01, options: .curveEaseOut, animations: {
            
            weakSelf?.tableView.tableHeaderView     = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: app_width, height:1.0))
            weakSelf?.mapView.frame                 = CGRect.init(x: 0.0, y: (weakSelf?.headerYOffSet)!, width: (weakSelf?.mapView.width)!, height: (weakSelf?.maxMap_h)!)
            weakSelf?.tableView.frame               = CGRect.init(x: 0.0, y: (weakSelf?.tableView_y)!, width: (weakSelf?.tableView.width)!, height: (weakSelf?.minTableView_h)!)
            weakSelf?.pin.center = CGPoint.init(x: (weakSelf?.mapView.center.x)!, y: (weakSelf?.mapView.center.y)! - (weakSelf?.pin.height)! / 2.0 * 3)
        }) { (finish : Bool) in
            
            weakSelf?.displayMap = true
        }
    }
    
    //MARK: 收缩地图
    func closeShutter() {
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, delay: 0.01, options: .curveEaseOut, animations: {
            
            weakSelf?.mapView.frame             = CGRect.init(x: 0, y: (weakSelf?.headerYOffSet)!, width: (weakSelf?.mapView.width)!, height: (weakSelf?.minMap_h)!)
            
            weakSelf?.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0.0, y: (weakSelf?.default_Y_tableView)!, width: app_width, height: 1.0))
            weakSelf?.tableView.frame           = CGRect.init(x: 0.0, y: (weakSelf?.default_Y_tableView)!, width: (weakSelf?.tableView.width)!, height: (weakSelf?.maxTableView_h)!)
            weakSelf?.pin.center = CGPoint.init(x: (weakSelf?.mapView.center.x)!, y: (weakSelf?.mapView.center.y)! - (weakSelf?.pin.height)! / 2.0 * 3)
            
        }) { (finish : Bool) in
            
            weakSelf?.displayMap = false
        }
    }
    
    //MARK: scrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        contentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollOffset : CGFloat = scrollView.contentOffset.y
        
        if scrollView.isDragging { // 拖拽
            
            if (scrollOffset - contentOffsetY) > 0 { //向上拖拽
                
                if self.mapView.height == self.maxMap_h {
                    
                    self.displayMap = false
                    self.closeShutter()
                }
            }
            else if (contentOffsetY - scrollOffset) > 10 { //向下拖拽
                
                if self.mapView.height == self.minMap_h {
                    
                    self.displayMap = true
                    self.openShutter()
                }
            }
        }
    }
}

//MARK: MAMapViewDelegate
extension LocationVC : MAMapViewDelegate {
    
    //地图移动结束后
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
        //位置发生变化后的操作
        if CCSingleton.sharedUser().latitude != mapView.centerCoordinate.latitude && CCSingleton.sharedUser().longitude != mapView.centerCoordinate.longitude {
            
            if self.dataArray.count > 0 {
                self.dataArray.removeAll()
            }
            
            self.tableView.rowHeight = self.tableView.height
            self.tableView.reloadData()
            
            self.activity.isHidden = false
            self.activity.startAnimating()
            
            CCSingleton.sharedUser().latitude = self.mapView.centerCoordinate.latitude
            CCSingleton.sharedUser().longitude = self.mapView.centerCoordinate.longitude
            
            self.initSearchs()
            
            weak var weakSelf = self
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.pin.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                
            }) { (finish : Bool) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    weakSelf?.pin.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                }) { (finish : Bool) in
                    
                }
            }
        }
    }
    
    //地图将要发生缩放
    func mapView(_ mapView: MAMapView!, mapWillZoomByUser wasUserAction: Bool) {
        
        if !self.displayMap {
            self.openShutter()
        }
    }
}

//MARK: UITableViewDataSource && UITableViewDelegate
extension LocationVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataArray.count == 0 {
            return 1
        }
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.dataArray.count == 0 {
            return tableView.height
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: Int = (indexPath as NSIndexPath).row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        if self.dataArray.count > 1 {
            if row == selectIndex {
                cell.mark.isHidden = false
            }
            else {
                cell.mark.isHidden = true
            }
            
            let mapPOI: AMapPOI = self.dataArray[row]
            cell.title.text = mapPOI.name
            
            let province : String = mapPOI.province //省
            let city : String = mapPOI.city //市
            let district : String = mapPOI.district; //区
            let address : String = mapPOI.address; //地址
            
            if district == address {
                cell.detail.text = province + city + address
            }
            else {
                cell.detail.text = province + city + district + address
            }
        }
        else {
            cell.mark.isHidden = true
            cell.title.text = ""
            cell.detail.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: Int = (indexPath as NSIndexPath).row
        self.selectIndex = row
        tableView.reloadData()
        
        let mapPOI: AMapPOI = self.dataArray[row]
        self.mapView.centerCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(mapPOI.location.latitude), longitude: CLLocationDegrees(mapPOI.location.longitude))
    }
}
