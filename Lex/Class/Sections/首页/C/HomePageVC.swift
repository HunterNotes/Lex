//
//  HomePageVC.swift
//  swift
//
//  Created by nbcb on 16/8/26.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomePageVC: RootViewController {
    
    let cellID:String = "cellID"
    
    // 标签
    var titlesView          : UIView!
    
    //底部红色指示器
    var indicatorView       : UIView!
    
    // 当前选中的按钮
    var selectedButton      : UIButton!
    
    //底部scrollView
    var contentView         : UIScrollView!
    
    var titleAlert          : UIAlertController!
    
    var time : TimeInterval = 0.0
    
    var selectedArr         : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgView.image = UIImage.init(named: "3E03A4F3-AA54-40E8-A7F2-A0CF25D7508C")
        self.view.addSubview(self.bgView)
        //        self.tableView.frame = CGRectMake(0, 44 + 20 + 25, app_width, tableView_height - 25)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        selectedArr = NSMutableArray()
        
        //        for _ in 0..<13 {
        //            selectedArr.add("0")
        //        }
        for _ in 0...12 {
            selectedArr.add("0")
        }
        registerCell()
    }
    
    //注册cell
    func registerCell() {
        
        //        let nib = UINib.init(nibName: String(HomePageCell), bundle: nil)
        //        self.tableView.registerNib(nib, forCellReuseIdentifier: cellID)
        self.tableView.register(UINib.init(nibName: "HomePageCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    //顶部标签栏
    func layoutTopView() {
        
    }
    
    func arrowButtonClick(_ sender: UIButton) {
        
    }
    
    func titlesClick(_ sender: UIButton) {
        
    }
    /// 底部的scrollview
    func setupContentView() {
        
    }
    
    //点赞
    func touchStar(_ sender: UIButton) {
        
        //        sender.isSelected = !sender.isSelected
        sender.isSelected = (self.selectedArr.object(at: sender.tag) as AnyObject).intValue == 0 ? false : true
        self.editStar(sender)
    }
    
    //取消弹框
    //    func dismissAlt(_ timer: Timer) {
    //
    //        self.time += 1
    //        if self.time == 4 {
    //            self.titleAlert.dismiss(animated: true, completion: nil)
    //            timer.invalidate()
    //        }
    //    }
    
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
            self.selectedArr.replaceObject(at: sender.tag, with: sender.isSelected)
        }
        self.tableView.reloadData()
        alertVC.addAction(cancel)
        alertVC.addAction(cofirm)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource、Delegate
extension HomePageVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 13
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section: Int = (indexPath as NSIndexPath).section
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomePageCell
        cell.imgView.image = UIImage.init(named: "IMG_0\(section)")
        cell.starBtn.isSelected = (selectedArr.object(at: section) as AnyObject).intValue == 0 ? false : true
        cell.starBtn.tag = section
        cell.starBtn.addTarget(self, action: #selector(touchStar(_:)), for: .touchUpInside)
        cell.imgTitle.text = "   清凉一夏，更多精彩等你呦"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "图片-\(section)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let msg: String = "车水马龙的喧嚣，敌不过此刻的有你真好"
        SVProgressHUD.showInfo(withStatus: msg)
        //        let alert: UIAlertController = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        //        alert.message = msg
        //        titleAlert = alert
        //        self.present(alert, animated: true, completion: nil)
        //
        //        let timer = Timer.init(timeInterval: 1, target: self, selector: #selector(dismissAlt(_:)), userInfo: nil, repeats: true)
        //        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        //        time = 0.0
        //        timer.fire()
    }
}
