//
//  UserInfoVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/11.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userInfoPhotoCell      : String = "UserInfoPhotoCell"
    let userInfoCommonCell     : String = "UserInfoCommonCell"
    let userInfoCommonNoneCell : String = "userInfoCommonNoneCell"
    let userInfoQRCodeCell     : String = "UserInfoQRCodeCell"
    
    /* 部分用户信息 */
    //    var imgName         : String!
    //    var userName        : String!
    var address         : String!
    var gender          : String!
    var location        : String!
    var signature       : String!
    
    var titleArr        : [[String]]!
    var detailArr       : [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "个人信息"
        self.initData()
        
        self.registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.initData()
        self.tableView.reloadData()
    }
    
    func initData() {
        
        address = ""
        gender = ""
        location = ""
        signature = ""
        
        titleArr = [["头像", "名字", "xx号", "我的二维码", "我的地址"], ["性别", "地区", "个性签名"], ["Linkedln账号"]]
        detailArr = [["", userName, "xx号", "我的二维码", address], [gender, location, signature], ["展示"]]
        
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "UserInfoPhotoCell", bundle: nil), forCellReuseIdentifier: userInfoPhotoCell)
        self.tableView.register(UINib.init(nibName: "UserInfoCommonCell", bundle: nil), forCellReuseIdentifier: userInfoCommonCell)
        self.tableView.register(UINib.init(nibName: "UserInfoCommonNoneCell", bundle: nil), forCellReuseIdentifier: userInfoCommonNoneCell)
        
        self.tableView.register(UINib.init(nibName: "UserInfoQRCodeCell", bundle: nil), forCellReuseIdentifier: userInfoQRCodeCell)
    }
}

extension UserInfoVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section : Int = (indexPath as NSIndexPath).section
        let row     : Int = (indexPath as NSIndexPath).row
        
        if section == 0 && row == 0 {
            return 65
        }
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5
        }
        else if section == 1 {
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section: Int = (indexPath as NSIndexPath).section
        let row: Int = (indexPath as NSIndexPath).row
        
        if section == 0 && row == 0 {
            
            let photoCell = tableView.dequeueReusableCell(withIdentifier: userInfoPhotoCell, for: indexPath) as! UserInfoPhotoCell
            photoCell.selectionStyle = .none
            photoCell.photo.image = userImg
            return photoCell
        }
        else if section == 0 && row == 3 {
            
            let qRCodeCell = tableView.dequeueReusableCell(withIdentifier: userInfoQRCodeCell, for: indexPath) as! UserInfoQRCodeCell
            qRCodeCell.selectionStyle = .none
            return qRCodeCell
        }
        else if section == 0 && row == 2 {
            
            let commonNoneCell = tableView.dequeueReusableCell(withIdentifier: userInfoCommonNoneCell, for: indexPath) as! UserInfoCommonNoneCell
            commonNoneCell.selectionStyle = .none
            commonNoneCell.leftLab.text = titleArr[section][row]
            commonNoneCell.rightLab.text = detailArr[section][row]
            return commonNoneCell
        }
        else {
            
            let commonCell = tableView.dequeueReusableCell(withIdentifier: userInfoCommonCell, for: indexPath) as! UserInfoCommonCell
            commonCell.selectionStyle = .none
            commonCell.accessoryType = .disclosureIndicator
            commonCell.leftLab.text = titleArr[section][row]
            commonCell.rightLab.text = detailArr[section][row]
            return commonCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 25
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section : Int = (indexPath as NSIndexPath).section
        let row     : Int = (indexPath as NSIndexPath).row
        
        switch section {
        case 0:
            switch row {
            case 0:
                
                let vc = EditPhotoVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = EditUserNameVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                
                break
            case 3:
                let vc = UserInfoQRCodeVC()
                vc.pushFlag = 0;
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                
                break
            default:
                break
            }
            
        case 1:
            switch row {
            case 0:
                
                break
            case 1:
                
                break
            case 2:
                
                break
            default:
                break
                
            }
        case 2:
            
            break
        default:
            break
        }
    }
}
