//
//  UserCenterVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/9.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit


var user            : User!

var userImg         : UIImage!

/// 原name
var userName        : String!

class UserCenterVC: UIViewController {
    
    let cellID          : String = "UserImgCell"
    let cell1ID         : String = "ZCommonCell"
    
    var userImgName     : String!
    
    var dataArr : [[String]]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImgName = "avatar_circle_default"
        self.dataArr = [[""], ["相册", "收藏", "钱包", "卡包"], ["表情"], ["设置"]]
        self.gisterCell()
        
        user = User()
        user.userName = "风一样的CC"
        user.imgStr = "--"
        user.id = 1
        userImg = UIImage(named: userImgName)
        if userName == nil || userName == "" {
            userName = "风一样的CC"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    //注册cell
    func gisterCell() {
        
        self.tableView.register(UINib.init(nibName: "UserImgCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.register(UINib.init(nibName: "ZCommonCell", bundle: nil), forCellReuseIdentifier: cell1ID)
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
            cell.userNameLab.text = userName
            cell.userNameLab.adjustsFontSizeToFitWidth = true
            cell.userNoLab.adjustsFontSizeToFitWidth = true
            cell.userImg.image = userImg
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
