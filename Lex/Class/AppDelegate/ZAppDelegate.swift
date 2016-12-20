//
//  ZAppDelegate.swift
//  Swift
//
//  Created by nbcb on 16/3/16.
//  Copyright © 2016年 nbcb. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import Reachability

@UIApplicationMain
class ZAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window          : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window!.backgroundColor = UIColor.white
        self.registerAppNotificationSettings(launchOptions)
        self.getLocation()
        let manager : SQLiteManager = SQLiteManager.defaultManager()
        manager.delete(TABLENAME)
        _ = manager.getImageFromSQLite(USER_IMGNAME)
        return true
    }
    
    //MARK: 注册消息推送
    fileprivate func registerAppNotificationSettings(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    print("iOS request notification success")
                }
                else {
                    print(" iOS 10 request notification fail")
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
    func getLocation() {
        
        let locationManager : CCLocationManager? = CCLocationManager.sharedManager()
        locationManager?.statusDelegate = self
        locationManager?.startLocation()
    }
    
    //MARK: 反编译地理位置
    func getLonLatToCity(_ loc : CLLocation) {
        
        let singleton = CCSingleton.sharedUser()
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placeMarks, error) -> Void in
            
            let errors : Error? = error
            
            //不能用(placeMarks?.count)! > 0 去判断，因WiFi下无法判断连接的是内网还是外网, 内网下(placeMarks?.count)!为nil会直接crash
            if (errors == nil) {
                
                reachabilityType = true
                
                let array = placeMarks! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                //国家
                let country: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! String
                singleton.country = country
                
                //国家代码
                let countryCode: String = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! String
                singleton.countryCode = countryCode
                
                //省
                let state: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                singleton.state = state
                
                //市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                singleton.city = city
                
                //区
                let subLocality: String = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! String
                singleton.subLocality = subLocality
                
                //街道位置
                let formattedAddressLines: String = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! String
                singleton.formattedAddressLines = formattedAddressLines
                print(formattedAddressLines)
                
                //具体位置
                let name: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! String
                singleton.name = name
                
                //我在这里去掉了“省”和“市” 项目需求 可以忽略
                singleton.state_Format = state.replacingOccurrences(of: "省", with: "") as String
                singleton.city_Format = city.replacingOccurrences(of: "市", with: "") as String
            }
            else {
                
                reachabilityType = false
                print("请确认连接的是外网")
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
        
        print("收到新消息Active\(userInfo)")
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
        print("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
        
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler()
    }
}

//MARK:- CCLocationManagerStatusDelegate
extension ZAppDelegate : CCLocationManagerStatusDelegate {
    
    func getLocationSuccess(_ location: CLLocation) {
        
        let reachability = Reachability.forInternetConnection()
        
        //判断网络链接状态
        if reachability!.isReachable() {
            
            self.getLonLatToCity(location)
            print("网络连接可用")
        }
        else {
            print("网络连接不可用")
        }
        
        //判断连接类型
        if reachability!.isReachableViaWiFi() {
            
            reachabilityType = true
            print("连接类型：WiFi")
        }
        else if reachability!.isReachableViaWWAN() {
            
            reachabilityType = true
            print("连接类型：蜂窝移动网络")
        }
        else {
            reachabilityType = false
            print("连接类型：没有网络连接")
        }
    }
    
    func getLocationFailure() {
        
        print("定位失败")
    }
    
    func deniedLocation() {
        
        print("权限被禁止，请在\"设置-隐私-定位服务\"中进行授权")
    }
}

