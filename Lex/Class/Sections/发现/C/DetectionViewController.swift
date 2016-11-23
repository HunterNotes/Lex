//
//  DetectionViewController.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/8.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class DetectionViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var dataArray: [DetectionModel]!
    let cellID:String = "cellID"
    let height: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layouScrollView()
        layoutTableView()
        
        self.dataArray = [DetectionModel]()
        for i in 0...9 {
            let car: DetectionModel = DetectionModel()
            car.money = Int(arc4random() % 100) + 1
            car.ID = "\(i)"
            if i % 2 == 0 {
                car.name = "宝马"
            }
            else {
                car.name = "奔驰"
            }
            self.dataArray.append(car)
        }
        self.gisterCell()
    }
    
    func layouScrollView() {
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 64, width:app_width, height: height))
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = UIColor.red
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize.init(width: 13 * app_width, height: 0)
        self.view.addSubview(self.scrollView)
        print(self.scrollView.contentSize)
        
        for page in 0...12 {
            
            let i  = CGFloat(page)
            let imgView = UIImageView.init(image: UIImage.init(named: "IMG_0\(page)"))
            imgView.frame = CGRect.init(x: i * app_width, y: -64, width: app_width, height: height) //坐标体系的问题，y：-64
            print(imgView.frame)
            
            self.scrollView.addSubview(imgView)
        }
    }
    
    func layoutTableView() {
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.scrollView.height + 64, width: app_width, height: app_height - self.scrollView.height - 64 - 49), style: .grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    
    //注册cell
    func gisterCell() {
        
        self.tableView.register(DetectionCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetectionViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DetectionCell
        cell.selectionStyle = .none
        let carModel = self.dataArray[indexPath.row]
        cell.setCell(carModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 20
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "\(section)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //
    //        return 10
    //    }
    
    //    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //
    //        return "\(section)"
    //    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension DetectionViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("只要滚动了就会触发哦。")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("开始拖拽视图")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("结束滚动")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("将开始降速时")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("减速停止了时执行，手触摸时执行执行")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("滚动动画停止时执行,代码改变时触发,也就是setContentOffset改变时")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("完成放大缩小时调用")
    }
}
