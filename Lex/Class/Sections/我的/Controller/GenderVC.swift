//
//  GenderVC.swift
//  Lex
//
//  Created by nbcb on 2017/1/12.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit


protocol GenderVCDelegate {

    func seletedGender(_ gender : String)
}

class GenderVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectRow           : Int? = -1
    var genderArr           : [String]? = ["男", "女"]
    var seletGenderDelegate : GenderVCDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navTitle = "性别"
        
        self.registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "GenderCell", bundle: nil), forCellReuseIdentifier: "GenderCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if self.selectRow != -1 {
            if self.seletGenderDelegate != nil {
                self.seletGenderDelegate?.seletedGender((self.genderArr?[self.selectRow!])!)
            }
        }
    }
}

extension GenderVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row : Int = (indexPath as NSIndexPath).row
        
        let cell : GenderCell = tableView.dequeueReusableCell(withIdentifier: "GenderCell", for: indexPath) as! GenderCell
        cell.selectionStyle = .none
        cell.genderLab.text = self.genderArr?[row]
        if self.selectRow == row {
            cell.selectImg.isHidden = false
        }
        else {
            cell.selectImg.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = (indexPath as NSIndexPath).row
        self.selectRow = row
        self.tableView.reloadData()
    }
}
