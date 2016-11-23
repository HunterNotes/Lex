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
    private func getConnection() ->Int {
        
        do {
            db =  try Connection("\(path)/db.sqlite")
        }
        catch _ {
            assert(false, "链接数据可以失败")
            return 0;
            
        }
        return 1;
    }
    
    // 创建表
    func createTable(tableName : String!) -> Table {
        
        print("\(path)")
        _ = getConnection();
        
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let imgName = Expression<String?>("imgName")
        
        arr = [id as AnyObject, name as AnyObject, imgName as AnyObject]
        
        //创建表
        try! db?.run(users.create(ifNotExists: true, block: { (table) in
            table.column(id, primaryKey: true)
            table.column(name)
            table.column(imgName)
//            table.column(imgName, unique: true)
        }))
        return users
    }
    
    //插入数据
    func insert(table : Table!) {

        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        let insert = table.insert(name <- userName, imgName <- "scuxiatian@foxmail.com")
        let rowid = (try! db?.run(insert))!
        print(rowid);
    }
    
    //查询数据
    func select(table : Table!) {
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>

        for user in (try! db?.prepare(table))! {
            print("Query:id: \(table[id]), name: \(table[name]), email: \(table[imgName])")
        }
    }
    
    //修改数据
    func upDate(table : Table!) {
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>

        let update = table.filter(id == rowid)
        try! db?.run(update.update(name <- name.replace("foxmail", with: "qq")))
        
        for user in (try! db?.prepare(table.filter(name == "究极死胖兽")))! {
            print("Update:id: \(table[id]), name: \(table[name]), imgName: \(table[imgName])")
        }
    }
    
    //删除数据
    func delete(table : Table) {
        
        let id          : Expression<Int64> = arr![0] as! Expression<Int64>
        let name        : Expression<String?> = arr![1] as! Expression<String?>
        let imgName     : Expression<String?> = arr![2] as! Expression<String?>
        

        try! db?.run(table.filter(id == rowid).delete())
        for user in (try! db?.prepare(table))! {
            print("Delete:id: \(table[id]), name: \(table[name]), imgName: \(table[imgName])")
        }
    }
    
    //获取存储标签
    func getSaveTitle() {
        
    }
}
