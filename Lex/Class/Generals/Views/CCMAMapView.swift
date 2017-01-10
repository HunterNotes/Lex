//
//  CCMAMapView.swift
//  Lex
//
//  Created by nbcb on 2017/1/10.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit


/// 地图
class CCMAMapView: MAMapView {

    //MARK: 放置大头针, 以移除添加的模式，但是大头针不是悬浮在地图的上方
    lazy var annotationss : Array<CCAnnotation> = {
        
        let arr : NSArray = NSArray()
        return arr as! [CCAnnotation]
    }()
    
    lazy var annotation : CCAnnotation = {
        
        let annotation : CCAnnotation = CCAnnotation()
        return annotation
    }()
    
    func setPin() {
        
        self.annotation.coordinate = self.centerCoordinate
        
        self.annotation.title = "title"
        self.annotation.subtitle = "subTitle"
        
        if self.annotations.count == 2 {
            self.removeAnnotation(self.annotation)
        }
        self.addAnnotation(self.annotation)
    }
    
    //MARK: 添加大头针
    func addAnnotation(_ coordinate: CLLocationCoordinate2D, title: String, subTitle: String) -> CCAnnotation {
        
        if self.annotations.count == 1 {
            
            //删除一颗大头针
            self.removeAnnotation(self.annotation)
            
            //删除全部大头针
            //            self.mapView.removeAnnotations(self.annotations)
        }
        self.annotation.coordinate = coordinate
        
        self.annotation.title = title
        self.annotation.subtitle = subTitle
        
        //添加一颗大头针
        self.addAnnotation(annotation)
        
        //添加多颗大头针
        //        self.mapView.addAnnotations(self.annotations)
        return annotation
    }
}

class CCAnnotation: NSObject, MAAnnotation {
    
    //大头针属性
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
}
