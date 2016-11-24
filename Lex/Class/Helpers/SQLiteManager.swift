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
    
    var db          : Connection? = nil
    var arr         : [AnyObject]!
    
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
    private func createTable(tableName : String!) -> Table {
        
        print("\(path)")
        //        _ = getConnection()
        
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
        return users
    }
    
    //插入数据
    func insert(tableName : String!, userName : String!, imgName : String!) {
        
        let table = self.createTable(tableName: tableName)
        
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let insert = table.insert(name <- userName, imgName <- imgName)
        let rowid = (try! db?.run(insert))!
        print(rowid);
    }
    
    //查询数据
    func select(tableName : String!) -> NSMutableDictionary {
        
        let table = self.createTable(tableName: tableName)
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        let dic = NSMutableDictionary()
        for user in (try! db?.prepare(table))! {
            print("Query:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
            dic.setObject(table[id], forKey:id as! NSCopying)
            dic.setObject(table[name], forKey: name as! NSCopying)
            dic.setObject(table[imgName], forKey: imgName as! NSCopying)
        }
        return dic
    }
    
    //修改数据
    func upDate(tableName : String!) {
        
        let table = self.createTable(tableName: tableName)
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        for user in (try! db?.prepare(table))! {
            
            let _name : String = user[name]!
            
            //数据不相等，不存储
            if (_name != USERNAME) {
                
                let list = table.filter(id == user[id])
                _ = try! db?.run(list.update(name <- name.replace(user[name]!, with: USERNAME!)))
                print("Update:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
            }
        }
        for user in (try! db?.prepare(table.filter(name == USERNAME)))! {
            print("Update:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
        }
    }
    
    //删除数据
    func delete(tableName : String!) {
        
        let table = self.createTable(tableName: tableName)
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        
        for user in (try! db?.prepare(table))! {
            
            _ = try! db?.run(table.filter(id == user[id]).delete())
            
        }
        for user in (try! db?.prepare(table))! {
            print("Delete:id: \(user[id]), name: \(user[name]), imgName: \(user[imgName])")
        }
    }
    
    //MARK: - 从本地数据库中获取用户头像
    func getUserImageFromSQLite() -> UIImage {
        
        //        let manager : SQLiteManager = SQLiteManager.defaultManager()
        let dic = self.select(tableName: TABLENAME)
        print(dic)
        
        //获取数据库中存取图片名称
        let imageName : NSString! = dic.object(forKey: "imgName") as! NSString!
        
        //字符串转化成NSData
        let data : NSData! = imageName.data(using: String.Encoding.utf8.rawValue) as NSData!
        
        //默认一张图片
        var image : UIImage? = UIImage.init(named: "avatar_circle_default")!
        
        if imageName.length != 0 {

            //NSData 转化成UIImage
            image = UIImage.init(data: data as Data)!
        }
        print("name = %@", dic.object(forKey: "name") ?? "--")
        return image!
    }
}
