//
//  UserCenterVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/9.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class UserCenterVC: UIViewController {
    
    let cellID          : String = "UserImgCell"
    let cell1ID         : String = "ZCommonCell"
    
    private var userImg : UIImage? = nil
    
    
    var dataArr         : [[String]]!
    var manager         : SQLiteManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataArr = [[""], ["相册", "收藏", "钱包", "卡包"], ["表情"], ["设置"]]
        self.gisterCell()
        
        manager = SQLiteManager.defaultManager()
        
        if Int(USERNAME.characters.count) == 0 {
            USERNAME = "风一样的CC"
        }
        
        weak var weakSelf = self
        saveImageBlock = { (str : String) -> () in
            
            if str == "saveImage" {
                weakSelf?.userImg = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func gisterCell() {
        
        self.tableView.register(UINib.init(nibName: "UserImgCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.register(UINib.init(nibName: "ZCommonCell", bundle: nil), forCellReuseIdentifier: cell1ID)
    }
    
    fileprivate func getUserImageFromSQLite(_ width : CGFloat = 50) -> UIImage {
        
        if self.userImg == nil {
            
            let img : UIImage = manager.getImageFromSQLite(USER_IMGNAME)
            let image = img.getRoundRectImage(width, 5, 1, UIColor.gray)
            self.userImg = image
        }
        return self.userImg!
    }
}

extension UserCenterVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section: Int = (indexPath as NSIndexPath).section
        
        if section == 0 {
            return 80
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section: Int = (indexPath as NSIndexPath).section
        let row: Int = (indexPath as NSIndexPath).row
        
        if section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                as! UserImgCell
            cell.selectionStyle = .none
            cell.userNameLab.text = USERNAME
            cell.userNameLab.adjustsFontSizeToFitWidth = true
            cell.userNoLab.adjustsFontSizeToFitWidth = true
            cell.userImg.image = self.getUserImageFromSQLite()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cell1ID, for: indexPath)
                as! ZCommonCell
            cell.selectionStyle = .none
            let name = self.dataArr[section][row]
            cell.iconImg.image = UIImage.init(named: name)
            cell.titleLab.text = name
            cell.titleLab.adjustsFontSizeToFitWidth = true
            cell.titleLab.text = name
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section : Int = (indexPath as NSIndexPath).section
        let row     : Int = (indexPath as NSIndexPath).row
        
        if section == 0 && row == 0 {
            
            let vc = UserInfoVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
