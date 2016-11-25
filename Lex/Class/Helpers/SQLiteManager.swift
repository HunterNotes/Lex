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
    private var table       : Table? = nil
    
    //多个地方调用获取图片的方法，消耗性能，故将获取到的图片设置成属性， 增、删、改之后会将图片置为nil，确保重新获取图片时，获取到的是最新的图片
    private var userImg     : UIImage? = nil
    
    override init() {
        
        // 获取链接（不存在文件，则自动创建）
        db =  try! Connection("\(path)/db.sqlite")
    }
    
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
    private func createTable(_ tableName : String!) -> Table {
        
        //        _ = getConnection()
        
        self.userImg = nil

        let users = Table(tableName)
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let imgName = Expression<String?>("imgName")
        
        arr = [id as AnyObject, name as AnyObject, imgName as AnyObject]
        
        //创建表 不存在就创建
        try! db?.run(users.create(ifNotExists: true, block: { (table) in
            table.column(id, primaryKey: true)
            table.column(name)
            table.column(imgName)
            //            table.column(imgName, unique: true)
        }))
        
        //确保是同一张表
        if tableName == TABLENAME {
            self.table = users
        }
        return users
    }
    
    //插入数据
    func insert(_ tableName : String!, _ userName : String!, _ imageName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        
        self.userImg = nil
        
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let insert = self.table?.insert(name <- userName, imgName <- imageName)
        let rowid = (try! db?.run(insert!))!
        print(rowid);
    }
    
    //查询数据
    func select(_ tableName : String!) -> NSMutableDictionary {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        let dic = NSMutableDictionary()
        for user in (try! db?.prepare(self.table!))! {
//            print("Query:id========================== \(user[id])\n name=========================== \(user[name])\n imgName========================== \(user[imgName])")
            dic.setObject("\(user[id])", forKey:"id" as NSCopying)
            dic.setObject("\(user[name])", forKey: "name" as NSCopying)
            dic.setObject("\(user[imgName])", forKey: "imgName" as NSCopying)
        }
        return dic
    }
    
    //修改数据
    func upDate(_ tableName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        self.userImg = nil
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        for user in (try! db?.prepare(self.table!))! {
            
            let _name : String = user[name]!
            
            //数据不相等，不存储
            if (_name != USERNAME) {
                
                let list = self.table?.filter(id == user[id])
                _ = try! db?.run((list?.update(name <- name.replace(user[name]!, with: USERNAME!)))!)
                print("Update:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
            }
        }
        for user in (try! db?.prepare((self.table?.filter(name == USERNAME))!))! {
            print("Update:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
        }
    }
    
    //删除数据
    func delete(_ tableName : String!) {
        
        if self.table == nil {
            self.table = self.createTable(tableName)
        }
        self.userImg = nil
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        for user in (try! db?.prepare(self.table!))! {
            
            _ = try! db?.run((self.table?.filter(id == user[id]).delete())!)
            
        }
        for user in (try! db?.prepare(self.table!))! {
            print("Delete:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
        }
    }
    
    //MARK: - 从本地数据库中获取用户头像
    func getUserImageFromSQLite() -> UIImage {
        
        let dic = self.select(TABLENAME)
        
        if dic.count > 0 {
            
            //获取数据库中存取图片名称
            let imageName : String? = dic.object(forKey: "imgName") as? String
            
            if  Int((imageName?.characters.count)!) > 0  {
                if self.userImg == nil {
                    self.userImg = SavaImgHelper.base64StringToUIImage(imageName!)
                    print("成功获取数据库中的图片")
                }
            }
        }
        if self.userImg == nil {
            self.userImg =  UIImage.init(named: "avatar_circle_default")!
        }
        return self.userImg!
    }
}
