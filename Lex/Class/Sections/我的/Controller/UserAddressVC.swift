//
//  UserAddressVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/20.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class UserAddressVC: BaseViewController, UpDateAddressVCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var address  : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = "我的地址"
        self.address = CCSingleton.sharedUser().name
        self.registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "ShowAddressCell", bundle: nil), forCellReuseIdentifier: "ShowAddressCell")
        self.tableView.register(UINib.init(nibName: "NewlyAddedAddressCell", bundle: nil), forCellReuseIdentifier: "NewlyAddedAddressCell")
    }
    
    func editAddress() {
        
        doGoUpDateAddressVC(0)
    }
    
    func doGoUpDateAddressVC(_ index: Int) {
        
        let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UpDateAddressVC") as! UpDateAddressVC
        vc.upDateAddressDelegate = self
        if index == 0 {
            vc.title = "修改地址"
        }
        else {
            vc.title = "新增地址";
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func upDateAddress(_ address: String) {
        
        self.address = address
        self.tableView.reloadData()
    }
}

extension UserAddressVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row     : Int = (indexPath as NSIndexPath).row
        
        if row == 0 {
            
            return 60
        }
        else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: Int = (indexPath as NSIndexPath).row
        
        if row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAddressCell", for: indexPath)
                as! ShowAddressCell
            cell.selectionStyle = .none
            cell.editAddressBtn.tag = row
            cell.userLab.text = USERNAME
            cell.address.text = self.address
            cell.editAddressBtn.addTarget(self, action: #selector(editAddress), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyAddedAddressCell", for: indexPath)
                as! NewlyAddedAddressCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row     : Int = (indexPath as NSIndexPath).row
        
        if row == 1 {
            doGoUpDateAddressVC(1)
        }
    }
}
