//
//  ZAppDelegate.swift
//  Swift
//
//  Created by nbcb on 16/3/16.
//  Copyright © 2016年 nbcb. All rights reserved.
//

import UIKit
import UserNotifications
//import CoreLocation
import Reachability
import SVProgressHUD

/** Bundle ID ：com.mr.zhou.Lex，一对一绑定， 不要改动，否则会导致无法定位
 */

@UIApplicationMain

class ZAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window          : UIWindow?
    var locationManager:AMapLocationManager!
    
    //高德地图定位
    private func configLocationManager() {
        
        self.locationManager = AMapLocationManager()
        self.locationManager.delegate = self
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.registerAppNotificationSettings(launchOptions)
        //        self.getLocation()
        let manager : SQLiteManager = SQLiteManager.defaultManager()
        manager.delete(TABLENAME)
        _ = manager.getImageFromSQLite(USER_IMGNAME)
        
        AMapServices.shared().apiKey = APIKey
        
        self.configLocationManager()
        self.locationManager.startUpdatingLocation()
        
        readCrashInfo();
        
        return true
    }
    
    func readCrashInfo() {
        
        weak var weakSelf = self
        
        DispatchQueue.global().async {
            
            if CrashManager.readAllCrashInfo().count == 0 {
                
                DispatchQueue.main.async {
                    
                    weakSelf?.goToLoadingVC()
                    return
                }
            }
        }
        
        //crash捕获
        crashHandle { (crashInfoArr) in
            
            CCLog(crashInfoArr.count)
            
            for info in crashInfoArr {
                
                //将上一次崩溃信息显示在屏幕上
                DispatchQueue.main.async {
                    
                    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    textView.backgroundColor = .gray
                    textView.textColor = .white
                    textView.isEditable = false
                    textView.text = info
                    
                    let tap = UITapGestureRecognizer(target: weakSelf, action: #selector(weakSelf?.tapGesture(_:)))
                    textView.addGestureRecognizer(tap)
                    UIApplication.shared.keyWindow?.addSubview(textView)
                }
            }
        }
    }
    
    func tapGesture(_ tap: UITapGestureRecognizer) {
        
        let label = UIApplication.shared.keyWindow?.subviews.last
        label?.removeFromSuperview()
        self.goToLoadingVC()
        tap.removeTarget(self, action: #selector(self.tapGesture(_:)))
    }
    
    func goToLoadingVC() {
        
        self.loadingVC.judjeCrashInfo()
        //        UIApplication.shared.keyWindow?.rootViewController = self.loadingVC
    }
    
    lazy var loadingVC : LoadingVC = {
        
        let loadingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingVC") as! LoadingVC
        return loadingVC
    }()
    
    //MARK: 注册消息推送
    fileprivate func registerAppNotificationSettings(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    CCLog("iOS request notification success")
                }
                else {
                    CCLog("iOS 10 request notification fail")
                }
            }
        }
        else { //iOS8, iOS9注册通知
            
            let setting = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //MARK: 获取地理位置信息
    //        func getLocation() {
    //
    //            let locationManager : CCLocationManager? = CCLocationManager.sharedManager()
    //            locationManager?.statusDelegate = self
    //            locationManager?.startLocation()
    //        }
    
    //MARK: 反编译地理位置
    func getLonLatToCity(_ loc : CLLocation) {
        
        let singleton = CCSingleton.sharedUser()
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placeMarks, error) -> Void in
            
            let errors : Error? = error
            
            //不能用(placeMarks?.count)! > 0 去判断，因WiFi下无法判断连接的是内网还是外网, 内网下(placeMarks?.count)!为nil会直接crash
            if (errors == nil) { //外网
                
                reachabilityType = true
                
                let array = placeMarks! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                let dic : Dictionary = mark.addressDictionary!
                
                singleton.longitude = loc.coordinate.longitude
                singleton.latitude = loc.coordinate.latitude
                
                //国家
                let country: String? = dic["Country"] as! String?
                singleton.country = country
                
                //国家代码
                let countryCode: String? = dic["CountryCode"] as! String?
                singleton.countryCode = countryCode
                
                //省
                let state: String? = dic["State"] as! String?
                singleton.state = state
                
                //市
                let city: String? = dic["City"] as! String?
                singleton.city = city
                
                //区
                let subLocality: String? = dic["SubLocality"] as! String?
                singleton.subLocality = subLocality
                
                //街道
                let thoroughfare : String? = dic["Thoroughfare"] as! String?
                singleton.thoroughfare = thoroughfare
                
                //街道具体位置
                let formattedAddressLines: String? = (dic["FormattedAddressLines"] as AnyObject).firstObject as! String?
                singleton.formattedAddressLines = formattedAddressLines
                CCLog(formattedAddressLines ?? "")
                
                //邮编
                let postalCode: String? = dic["postalCode"] as? String
                singleton.postalCode = postalCode
                
                //具体位置
                let name: String? = dic["Name"] as? String
                singleton.name = name
                
                //我在这里去掉了“省”和“市” 项目需求 可以忽略
                singleton.state_Format = (state?.replacingOccurrences(of: "省", with: ""))! as String
                singleton.city_Format = (city?.replacingOccurrences(of: "市", with: ""))! as String
            }
            else { //内网
                
                let reachability = Reachability.forInternetConnection()
                
                //判断网络链接状态
                if reachability!.isReachable() {
                    
                    if reachability!.isReachableViaWiFi() {
                        
                        reachabilityType = false
                        CCLog("网络连接类型：内网WiFi")
                        
                        SVProgressHUD.showError(withStatus: "请确认连接的是外网")
                    }
                }
                else {
                    
                    SVProgressHUD.showError(withStatus: "网络连接不可用，请确认网络已连接")
                }
            }
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        
        CCLog("收到新消息Active\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }
        else {
            // 代表从后台接受消息后进入app
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler(.newData)
    }
}

extension ZAppDelegate : UNUserNotificationCenterDelegate {
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        CCLog("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
        
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        CCLog("userInfo10:\(userInfo)")
        completionHandler()
    }
}

//MARK:- CCLocationManagerStatusDelegate
//extension ZAppDelegate : CCLocationManagerStatusDelegate {
//
//    func getLocationSuccess(_ location: CLLocation) {
//
//        let reachability = Reachability.forInternetConnection()
//
//        //判断网络链接状态
//        if reachability!.isReachable() {
//
//            self.getLonLatToCity(location)
//            CCLog("网络连接可用")
//        }
//        else {
//            CCLog("网络连接不可用")
//        }
//
//        //判断连接类型
//        if reachability!.isReachableViaWiFi() {
//
//            reachabilityType = true
//            CCLog("连接类型：WiFi")
//        }
//        else if reachability!.isReachableViaWWAN() {
//
//            reachabilityType = true
//            CCLog("连接类型：蜂窝移动网络")
//        }
//        else {
//            reachabilityType = false
//            CCLog("连接类型：没有网络连接")
//            SVProgressHUD.showError(withStatus: "请确认网络已连接")
//        }
//    }
//
//    func getLocationFailure() {
//
//        CCLog("定位失败")
//    }
//
//    func deniedLocation() {
//
//        CCLog("权限被禁止，请在\"设置-隐私-定位服务\"中进行授权")
//    }
//}

//MARK: AMapLocationManagerDelegate
extension ZAppDelegate : AMapLocationManagerDelegate {
    
    // 发生了错误
    func amapLocationManager(_ manager:AMapLocationManager, didFailWithError error:Error) {
        CCLog("error:\(error)")
    }
    
    // 更新定位
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        CCLog("经度:\(location.coordinate.longitude), 纬度:\(location.coordinate.latitude)")
        
        self.getLonLatToCity(location)
        self.locationManager.stopUpdatingLocation()
    }
}
