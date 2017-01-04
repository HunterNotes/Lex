//
//  LocationVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/26.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationVCDelegate {
    
    // Tap handlers
    func didTapOnMapView()
    func didTapOnTableView()
    
    // TableView's move
    func didTableViewMoveDown()
    func didTableViewMoveUp()
    
}

class LocationVC: BaseViewController, SearchDelegate {
    
    @IBOutlet weak var searchBtn    : UIButton!
    
    var selectIndex                 : Int = 0
    var hiddenSearch                : Bool = false
    var displayMap                  : Bool = true  //地图状态：是否展开
    
    let minTableView_h              : CGFloat = app_height - 379
    let maxTableView_h              : CGFloat = app_height - 244
    let tableView_y                 : CGFloat = 379.0
    let minMap_h                    : CGFloat = 135.0
    let maxMap_h                    : CGFloat = 270.0
    let headerYOffSet               : CGFloat = 109.0
    let default_Y_tableView         : CGFloat = 244.0
    var contentOffsetY              : CGFloat = 0
    
    var locDelegate                 : LocationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.view.addSubview(self.naBar)
        self.setupMapView()
        //        self.initAnnotations()
        
        self.setupTableView()
        self.registerCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.gpsAction()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
    }
    
    func setupTableView() {
        
        self.view.addSubview(self.tableView)
    }
    
    //MARK: 导航条相关
    lazy var naBar: PresentNaBarView = {
        
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
    
    //MARK: SearchDelegate
    func hideSearchView(status : Bool) {
        
        self.hiddenSearch = false
        self.touchSearchAnimation()
        
        if status == true {
            self.search.removeFromSuperview()
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
    }
    
    lazy var tableView : UITableView = {
        
        let tab : UITableView = UITableView.init(frame: CGRect.init(x: 0, y: self.tableView_y, width: app_width, height: self.minTableView_h), style: .grouped)
        tab.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 1.0))
        tab.tableHeaderView?.backgroundColor = globalBGColor()
        tab.dataSource = self
        tab.delegate = self
        return tab
    }()
    
    //MARK: 手势相关
    lazy var tapMapGesture : UITapGestureRecognizer = {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(LocationVC.handleTapMapView(_:)))
        return tap
    }()
    
    func handleTapMapView(_ gesture : UIGestureRecognizer) {
        
        if !self.displayMap {
            
            self.openShutter()
            self.locDelegate?.didTapOnMapView()
        }
    }
    
    //MARK: 高德地图相关
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
    
    lazy var mapView : MAMapView = {
        
        let map : MAMapView = MAMapView(frame: CGRect.init(x: 0, y: 109, width: app_width, height: self.maxMap_h))
        map.delegate = self
        map.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        map.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        map.showsUserLocation = true
        
        //最小更新距离
        map.distanceFilter = 5
        
        //设置比例尺
        map.zoomLevel = 50
        return map
    }()
    
    func setupMapView() {
        
        //        self.view.insertSubview(mapView, belowSubview: self.tableView)
        self.view.addSubview(self.mapView)
        let zoomPannelView = self.makeZoomPannelView
        //        zoomPannelView.center = CGPoint.init(x: self.topView.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.topView.bounds.size.height -  zoomPannelView.bounds.width/2 - 30)
        
        zoomPannelView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleLeftMargin]
        self.mapView.addSubview(self.makeZoomPannelView)
        self.mapView.addSubview(self.gpsButton)
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
            self.setPin()
        }
    }
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first?.location(in: self.mapView)
        let coordinate = self.mapView.convert(point!, toCoordinateFrom: self.mapView)
        let annotation = addAnnotation(coordinate, title: "title", subTitle: "subTitle")//注意：占位标题与占位子标题
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (pls: [CLPlacemark]?, error: Error?) -> Void in
            if error == nil {
                let pl = pls?.first
                print(pl ?? "")
                annotation.title = pl?.locality//上海市
                annotation.subtitle = pl?.name//金桥谷创意园
            }
        }
    }
    
    //MARK: 放置大头针
    
    lazy var annotations : Array<CCAnnotation> = {
        
        let arr : NSArray = NSArray()
        return arr as! [CCAnnotation]
    }()
    
    lazy var annotation : CCAnnotation = {
        
        let annotation : CCAnnotation = CCAnnotation()
        return annotation
    }()
    
    func setPin() {
        
        self.annotation.coordinate = CLLocationCoordinate2DMake(CCSingleton.sharedUser().latitude, CCSingleton.sharedUser().longitude);
        
        //一个点放置大头针
        self.mapView.addAnnotation(self.annotation)
        
        //多个点防止大头针
        //        self.annotations.append(self.annotation)
        //        self.mapView.addAnnotations(self.annotations)
    }
    
    func addAnnotation(_ coordinate: CLLocationCoordinate2D, title: String, subTitle: String) -> CCAnnotation {
        
        if self.mapView.annotations.count > 0 {
            
            //删除一颗大头针
            self.mapView.removeAnnotation(self.annotation)
            
            //删除全部大头针
            //            self.mapView.removeAnnotations(self.annotations)
        }
        self.annotation.coordinate = coordinate
        self.annotation.title = title
        self.annotation.subtitle = subTitle
        
        //添加一颗大头针
        self.mapView.addAnnotation(annotation)
        
        //添加多颗大头针
        //        self.mapView.addAnnotations(self.annotations)
        
        return annotation
    }
    
    //MARK: 展开地图
    func openShutter() {
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, delay: 0.01, options: .curveEaseOut, animations: {
            
            weakSelf?.tableView.tableHeaderView     = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: app_width, height:1.0))
            weakSelf?.mapView.frame                 = CGRect.init(x: 0.0, y: (weakSelf?.headerYOffSet)!, width: (weakSelf?.mapView.width)!, height: (weakSelf?.maxMap_h)!)
            weakSelf?.tableView.frame               = CGRect.init(x: 0.0, y: (weakSelf?.tableView_y)!, width: (weakSelf?.tableView.width)!, height: (weakSelf?.minTableView_h)!)
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
        
        print(mapView.userLocation)
    }
    
    //地图移动结束后
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
        print(mapView.userLocation)
        
        //经度
        //mapView.userLocation.location.coordinate.longitude
        
        //纬度
        //mapView.userLocation.location.coordinate.latitude
        
        //反编译地理位置
    }
    
    //地图将要发生缩放
    func mapView(_ mapView: MAMapView!, mapWillZoomByUser wasUserAction: Bool) {
        
        if !self.displayMap {
            
            self.openShutter()
            self.locDelegate?.didTapOnMapView()
        }
    }
    
    //地图缩放结束
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        
    }
    
    //定位成功后生成指定的标注View
    //    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
    //
    //        if annotation.isKind(of: MAPointAnnotation.self) {
    //            let pointReuseIndetifier = "pointReuseIndetifier"
    //            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
    //
    //            if annotationView == nil {
    //                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
    //            }
    //
    //            annotationView!.canShowCallout = true
    //            annotationView!.animatesDrop = true
    //            annotationView!.isDraggable = true
    //            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
    //
    //            let idx = annotations.index(of: annotation as! MAPointAnnotation)
    //            annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx!)!
    //
    //            return annotationView!
    //        }
    //        return nil
    //    }
    
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
        
        return tableView.height / 10.0
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: Int = (indexPath as NSIndexPath).row
        self.selectIndex = row
        tableView.reloadData()
    }
}

class CCAnnotation: NSObject, MAAnnotation {
    
    //大头针属性
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
}
