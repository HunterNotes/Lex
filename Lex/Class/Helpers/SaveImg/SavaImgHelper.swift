//
//  SavaImgHelper.swift
//  Lex
//
//  Created by nbcb on 2016/11/25.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class SavaImgHelper: NSObject {
    
    //MARK: - UIImage转base64字符串, 默认带有data标识,
    class func imageToBase64String(_ image : UIImage, _ headerSign : Bool = true) -> String? {
        
        //根据图片得到对应的二进制编码
        //UIImage转为data 不压缩
        //        let imgData : NSData = UIImagePNGRepresentation(img)! as NSData
        
        //UIImage转为data 压缩图片质量 代替 UIImagePNGRepresentation
        guard let imgData : Data = UIImageJPEGRepresentation(image, 0.1) else {
            return "--"
        }
        
        //根据二进制编码得到对应的base64字符串
        var base64String = imgData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        //判断是否带有头部base64标识信息
        if headerSign {
            
            //根据格式拼接数据头 添加header信息，扩展名信息  !!!!!!不拼接上数据头，data转为UIImage时始终🔙nil 暂时没弄清楚原因!!!!!!!
            base64String = BASE64HEADER + base64String
        }
        return base64String
    }
    
    //MARK: - image名称转base64字符串, 默认带有data标识,
    class func imageNameToBase64String(_ imageName : String, _ headerSign : Bool = true) -> String? {
        
        ///根据名称获取图片
        guard let image : UIImage = UIImage(named:imageName) else {
            return nil
        }
        return imageToBase64String(image, headerSign)
    }
    
    //MARK: - base64字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
    class func base64StringToImage(_ base64String : String) -> UIImage? {
        
        var str : String! = base64String
        
        // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
        if str.contains(BASE64HEADER) {
            //            if (str!.hasPrefix(BASE64HEADER)) {
            guard let newBase64String = str!.components(separatedBy: ",").last else {
                return nil
            }
            str = newBase64String
            //            }
        }
        
        // 2、将处理好的base64String代码转换成NSData
        guard let imgNSData = Data.init(base64Encoded: str, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        // 3、将NSData的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData) else {
            return nil
        }
        return codeImage
    }
    
    func rangeOfString(_ subString : String?, _ allString : String?) -> Int {
        
        if Int(subString!.count) != 0 && Int(allString!.count) != 0 {
            
            guard (allString?.range(of: subString!)) != nil else {
                return 0
            }
        }
        return -1
    }
}
