//
//  RootViewController.swift
//  Swift Demo
//
//  Created by nbcb on 16/8/30.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

/**
 * 基础控制器类 此项目所有VC皆继承于该类，使用时在子类中将bgView, tableView添加在sele.view上，tableView选择性的添加
 *
 */

class RootViewController: UIViewController {
    
    var tableView           : UITableView!
    var bgView              : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加背景视图
        layoutBGView()
        
        //添加tableview
        layoutRootTableView()
    }
    
    fileprivate func layoutBGView() {
        
        self.bgView = UIImageView.init(image: UIImage.init(named: "home_bg"))
        self.bgView.frame = tableView_frame
    }
    
    fileprivate func layoutRootTableView() {
        
        self.tableView = UITableView.init(frame: tableView_frame, style: .plain)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.gray
    }
    
    /**
     * 此处暂时添加常用方法
     *
     */
//    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
//        
//        return 80
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
//        
//        let identifier = "cell"
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 20
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        
//    }
}
