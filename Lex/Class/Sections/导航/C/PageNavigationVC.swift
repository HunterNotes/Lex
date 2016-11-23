//
//  PageNavigationVC.swift
//  Swift
//
//  Created by nbcb on 16/3/16.
//  Copyright © 2016年 nbcb. All rights reserved.
//

import UIKit


class PageNavigationVC: RootViewController {
    
    let identifier = "cellID"
    
    fileprivate var label : ZLabel!
    var flagArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.bgView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        flagArray = NSMutableArray.init()
        for _ in 0...5 {
            flagArray.add("0")
        }
        
        //注册cell
        regiesterCell()
    }
    
    func regiesterCell() {
        
        self.tableView.register(UINib (nibName: "ZTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
    }
    
    func getStringLength(_ string: String) -> Int {
        
        let length: Int = 0
        return length
    }
    
    func touchAction (_ sender: UIButton) {
        
        sender.isSelected = (self.flagArray.object(at: sender.tag) as AnyObject).intValue == 0 ? false : true
        self.editStar(sender)
    }
    
    func editStar(_ sender : UIButton) {
        
        var msg: String = "取消收藏"
        if !sender.isSelected {
            msg = "确定收藏"
        }
        
        let alertVC = UIAlertController.init(title: "提示", message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (alert : UIAlertAction) in
            
        }
        let cofirm = UIAlertAction.init(title: "确定", style: .default) { (alert : UIAlertAction) in
            
            sender.isSelected = !sender.isSelected
            self.flagArray.replaceObject(at: sender.tag, with: sender.isSelected)
        }
        self.tableView.reloadData()
        alertVC.addAction(cancel)
        alertVC.addAction(cofirm)
        self.present(alertVC, animated: true, completion: nil)
    }
}


extension PageNavigationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 455
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section: Int = (indexPath as NSIndexPath).section
        let row: Int = (indexPath as NSIndexPath).row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            as! ZTableViewCell
        cell.selectionStyle = .none
        cell.leftlabel.adjustsFontSizeToFitWidth = true
        cell.starBtn.tag = section + row
        cell.starBtn.isSelected = (flagArray.object(at: section) as AnyObject).intValue == 0 ? false :true
        let imageName: String = "IMG_" + "\(section)"
        cell.photoView.image = UIImage.init(named: imageName)
        cell.starBtn.addTarget(self, action:#selector(touchAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "图片-\(section)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    
    //     func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //
    //        return nil
    //    }
    
    //     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //
    //        return 5
    //    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
