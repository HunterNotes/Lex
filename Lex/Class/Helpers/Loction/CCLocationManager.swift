//
//  CCLocationManager.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/17.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

//通过系统定位获取位置信息

/**
 *  获取定位状态协议
 */
@objc protocol CCLocationManagerStatusDelegate {
    
    //MARK: - 定位成功
    func getLocationSuccess(_ location: CLLocation)
    
    //MARK: - 定位失败
    func getLocationFailure()
    
    //MARK: - 如果定位服务被禁止
    @objc optional func deniedLocation()
}

class CCLocationManager: NSObject {
    
    fileprivate var manager             : CLLocationManager!
    var locationList                : NSArray!
    var statusDelegate              : CCLocationManagerStatusDelegate!
    
    /* 用户位置信息 */
    // 国家
    var country                     : String!
    
    // 国家代码
    var countryCode                 : String!
    
    // 省
    var state                       : String!
    
    // 市
    var city                        : String!
    
    // 区
    var subLocality                 : String!
    
    // 街道地址
    var formattedAddressLines       : String!
    
    // 具体位置
    var name                        : String!
    
    // 去掉 "省"
    var state_Format                : String!
    
    // 去掉 "市"
    var city_Format                 : String!
    
    /* 定位状态 */
    var locationStatus              : Bool = true
    
    override init() {
        
        self.manager = CLLocationManager()
    }
    
    //MARK: - 单例 创建 CCLocationManager
    class func sharedManager() -> CCLocationManager {
        
        struct single {
            static var locationManager : CCLocationManager? = CCLocationManager()
        }
        single.locationManager?.manager.delegate = single.locationManager
        
        //设备使用电池供电时最高的精度
        single.locationManager?.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters //kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            single.locationManager?.manager.requestWhenInUseAuthorization()
        }
        //变化距离 超过1000米 重新定位
        single.locationManager?.manager.distanceFilter = kCLLocationAccuracyKilometer
        return single.locationManager!
    }
    
    //MARK: - 开始定位
    func startLocation() {
        
        if self.checkGps() {
            if self.manager.responds(to:#selector(CLLocationManager.requestAlwaysAuthorization)) {
                self.manager.requestAlwaysAuthorization()
            }
            self.manager.startUpdatingLocation()
        }
        else {
            CCLog("权限被禁止，请在\"设置-隐私-定位服务\"中进行授权")
        }
    }
    
    //MARK: - 检查定位服务
    func checkGps() -> Bool {
        
        let authStatus : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        //确定用户的定位服务启用
        if !CLLocationManager.locationServicesEnabled() {
            return false
        }
        
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            return true
        case .restricted, .denied:
            if (self.statusDelegate != nil) {
                self.statusDelegate.deniedLocation!()
            }
            return false
        }
    }
    
    //MARK: - 停止定位
    func stopLocation() {
        self.manager.stopUpdatingLocation()
    }
    
    //MARK: - 获取最新的定位的经纬度
    func lastestLocation() -> CLLocationCoordinate2D {
        
        if self.locationStatus {
            if CCLocationManager.sharedManager().locationList == nil {
                return CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
            else {
                let currLocation:CLLocation = CCLocationManager.sharedManager().locationList.lastObject as! CLLocation
                let currCoordinate:CLLocationCoordinate2D = currLocation.coordinate
                return currCoordinate
            }
        }
        else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
    //MARK: - 记录定位是否成功
    func getLocationStatus() -> Bool {
        return self.locationStatus
    }
}

// MARK: - CLLocationManagerDelegate
extension CCLocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationStatus = true
        let location : CLLocation = locations[locations.count - 1]
        self.statusDelegate.getLocationSuccess(location)
        self.locationList = locations as NSArray!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.locationStatus = false
        self.locationList = []
        self.statusDelegate.getLocationFailure()
    }
}
