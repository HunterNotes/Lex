//
//  SQLiteManager.swift
//  Lex
//
//  Created by cc on 2016/11/23.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SQLite

class SQLiteManager: NSObject {
    
    var db                  : Connection? = nil
    var arr                 : [AnyObject]!
    fileprivate var table       : Table? = nil
    
    /**
     * 多个地方调用获取图片的方法，消耗性能，故将获取到的图片设置成属性， 增、删、改之后会将图片置为nil，确保重新获取图片时，获取到的是最新的图片
     */
    fileprivate var userImg     : UIImage? = nil     //用户头像
    fileprivate var qrImg       : UIImage? = nil     //用户二维码
    
    fileprivate var userImgStr  : String? = nil      //用户头像名称
    fileprivate var qrImgStr    : String? = nil      //用户二维码图片名称
    
    override init() {
        
        // 获取链接（不存在文件，则自动创建）
        db =  try! Connection("\(path)/db.sqlite")
    }
    
    //MARK: 单列
    class func defaultManager() -> SQLiteManager {
        
        struct single {
            static var manager : SQLiteManager? = SQLiteManager()
        }
        return single.manager!
    }
    
    // 文件路径
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    // 获取链接（不存在文件，则自动创建）
    //    private func getConnection() ->Int {
    //
    //        do {
    //            db =  try Connection("\(path)/db.sqlite")
    //        }
    //        catch _ {
    //            assert(false, "链接数据可以失败")
    //            return 0;
    //        }
    //        return 1;
    //    }
    
    // 创建表
    fileprivate func createTable(_ tableName : String!) -> Table {
        
        //        _ = getConnection()
        
        self.userImg = nil
        self.qrImg = nil
        
        let users = Table(tableName)
        let id = Expression<Int64>(USER_ID)
        let name = Expression<String?>(USER_NAME)
        let imgName = Expression<String?>(USER_IMGNAME)
        let qrName = Expression<String?>(USER_QRIMGNAME)
        
        arr = [id as AnyObject, name as AnyObject, imgName as AnyObject, qrName as AnyObject]
        
        //创建表 不存在就创建
        try! db?.run(users.create(ifNotExists: true, block: { (table) in
            table.column(id, primaryKey: true)
            table.column(name)
            table.column(imgName)
            table.column(qrName)
        }))
        
        //确保是同一张表
        if tableName == TABLENAME {
            self.table = users
        }
        return users
    }
    
    //插入数据
    func insert(_ tableName : String!, _ userName : String!, _ imageName : String!, _ qrImgName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        
        self.userImg = nil
        self.qrImg = nil
        
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let qrName   : Expression<String?> = arr![3] as! Expression<String?>
        let insert = self.table?.insert(name <- userName, imgName <- imageName,  qrName <- qrImgName)
        let rowid = (try! db?.run(insert!))!
        print(rowid);
    }
    
    //查询数据
    func select(_ tableName : String!) -> Dictionary<String, String> {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let qrName      : Expression<String?> = arr![3] as! Expression<String?>
        
        var dic = Dictionary<String, String>()
        for user in (try! db?.prepare(self.table!))! {
            //            print("Query: id========================== \(user[id]), \n name=========================== \(user[name]), \n imgName========================== \(user[imgName]), \n qrName =====================\(user[qrName])")
            dic = [USER_ID : "\(user[id])", USER_NAME : "\(user[name])", USER_IMGNAME : "\(user[imgName])", USER_QRIMGNAME : "\(user[qrName])"]
        }
        return dic
    }
    
    //修改数据
    func upDate(_ tableName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        self.userImg = nil
        self.qrImg = nil
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let qrName      : Expression<String?> = arr![3] as! Expression<String?>
        
        for user in (try! db?.prepare(self.table!))! {
            
            let _name : String = user[name]!
            
            //数据不相等，不存储
            if (_name != USERNAME) {
                
                let list = self.table?.filter(id == user[id])
                
                //更新数据
                _ = try! db?.run((list?.update(name <- name.replace(user[name]!, with: USERNAME!)))!)
                print("Update: id==================== \(user[id]), \n name==================== \(user[name]), \n imgName==================== \(user[imgName])\n qrName==================== \(user[qrName])")
            }
        }
        
        //读取数据
        for user in (try! db?.prepare((self.table?.filter(name == USERNAME))!))! {
            print("Update: id==================== \(user[id]), \n name==================== \(user[name]), \n imgName==================== \(user[imgName])\n qrName==================== \(user[qrName])")
        }
    }
    
    //删除数据
    func delete(_ tableName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        self.userImg = nil
        self.qrImg = nil
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let qrName      : Expression<String?> = arr![3] as! Expression<String?>
        
        //读取数据
        for user in (try! db?.prepare(self.table!))! {
            
            _ = try! db?.run((self.table?.filter(id == user[id]).delete())!)
        }
        for user in (try! db?.prepare(self.table!))! {
            print("Update: id==================== \(user[id]), \n name==================== \(user[name]), \n imgName==================== \(user[imgName])\n qrName==================== \(user[qrName])")
        }
    }
    
    //MARK: - 从本地数据库中获取用户头像/二维码
    func getImageFromSQLite(_ name : String) -> UIImage {
        
        var dic : Dictionary<String, String>? = nil
        
        if name == USER_IMGNAME {   //头像
            if self.userImg == nil {
                
                dic = select(name)
                if dic?.count > 0 {
                    
                    //获取数据库中存取图片名称
                    self.userImgStr = dic?[USER_IMGNAME]
                    if Int((self.userImgStr?.characters.count)!) > 0  {
                        if self.userImg == nil {
                            
                            self.userImg = SavaImgHelper.base64StringToImage(self.userImgStr!)
                            print("成功获取数据库中的用户头像")
                        }
                    }
                }
                //默认一张头像
                if self.userImg == nil {
                    
                    self.userImg =  UIImage.init(named: "UserImg")!
                    self.userImgStr = SavaImgHelper.imageToBase64String(self.userImg!)
                }
            }
            return self.userImg!
        }
        else {   //二维码
            
            if self.qrImg == nil {
                
                dic = self.select(name)
                if dic?.count > 0 {
                    
                    //获取数据库中存取图片名称
                    self.qrImgStr = dic?[USER_QRIMGNAME]
                    
                    if  Int((self.qrImgStr?.characters.count)!) > 0  {
                        if self.qrImg == nil {
                            
                            self.qrImg = SavaImgHelper.base64StringToImage(self.qrImgStr!)
                            print("成功获取数据库中的二维码图片")
                        }
                    }
                }
                
                //默认一张二维码 防止反复生成二维码
                if self.qrImg == nil {
                    
                    //生成高清二维码
                    let image: UIImage = QRTEXT.generateQRCodeWithLogo(self.userImg)
                    
                    //生成base64为字符串
                    self.qrImgStr = SavaImgHelper.imageToBase64String(image)!
                    
                    if self.qrImgStr != "--" {
                        
                        let qrImgSize : Int = self.qrImgStr!.characters.count / 1024
                        print("二维码大小为", qrImgSize, "KB");
                    }
                    
                    //压缩图片
                    self.qrImg = SavaImgHelper.base64StringToImage(self.qrImgStr!)
                    
                    //先清空表
                    delete(TABLENAME)
                    
                    //插入数据
                    insert(TABLENAME, USERNAME, self.userImgStr, self.qrImgStr)
                }
                
                self.userImg = getImageFromSQLite(USER_IMGNAME)
                self.qrImg = getImageFromSQLite(USER_QRIMGNAME)
            }
            return self.qrImg!
        }
    }
}
