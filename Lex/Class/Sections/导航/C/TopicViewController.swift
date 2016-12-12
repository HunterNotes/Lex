//
//  TopicViewController.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class TopicViewController: UITableViewController {//
    
    let homeCellID = "homeCellID"
    
    class YMTopicViewController: UITableViewController {
        
        var type = Int()
        
        /// 首页列表数据
        var items = [YMHomeItem]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = globalBGColor()
            
            setupTableView()
            
            // 添加刷新控件
            refreshControl = YMRefreshControl()
            refreshControl?.beginRefreshing()
            refreshControl?.addTarget(self, action: #selector(loadHomeData), for: .valueChanged)
            // 获取首页数据
            NetworkManager.shareNetwork().loadHomeInfo(type) { [weak self] (homeItems) in
                self!.items = homeItems
                self!.tableView!.reloadData()
                self!.refreshControl?.endRefreshing()
            }
        }
        
        func loadHomeData() {
            // 获取首页数据
            YMNetworkTool.shareNetworkTool.loadHomeInfo(type) { [weak self] (homeItems) in
                self!.items = homeItems
                self!.tableView!.reloadData()
                self!.refreshControl?.endRefreshing()
            }
        }
        
        func setupTableView() {
            tableView.rowHeight = 160
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsetsMake(kTitlesViewY + kTitlesViewH, 0, tabBarController!.tabBar.height, 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
            let nib = UINib(nibName: String(describing: YMHomeCell), bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: homeCellID)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    
    extension TopicViewController: HomeCellDelegate {
        // MARK: - UITableViewDataSource
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count ?? 0
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let homeCell = tableView.dequeueReusableCell(withIdentifier: homeCellID) as! YMHomeCell
            homeCell.selectionStyle = .none
            homeCell.homeItem = items[indexPath.row]
            homeCell.delegate = self
            return homeCell
        }
        // MARK: - UITableViewDelegate
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = YMDetailViewController()
            detailVC.homeItem = items[indexPath.row]
            detailVC.title = "攻略详情"
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        // MARK: - YMHomeCellDelegate
        func homeCellDidClickedFavoriteButton(_ button: UIButton) {
            if !UserDefaults.standard.bool(forKey: isLogin) {
                let loginVC = YMLoginViewController()
                loginVC.title = "登录"
                let nav = YMNavigationController(rootViewController: loginVC)
                present(nav, animated: true, completion: nil)
            } else {
                
            }
        }
        
}
