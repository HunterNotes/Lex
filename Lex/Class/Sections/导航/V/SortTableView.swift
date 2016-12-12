//
//  SortTableView.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

let sortTableViewCellID = "sortTableViewCellID"

protocol SortTableViewDelegate: NSObjectProtocol {
    func sortView(_ sortView: SortTableView, didSelectSortAtIndexPath sort: String)
}

class SortTableView: UIView {
    
    weak var delegate: SortTableViewDelegate?
    
    let cells = ["默认排序", "按热度排序", "价格从低到高", "价格从高到低"]
    /// 排序方式
    let sorts = ["", "hot", "price%3Aasc", "price%3Adesc"]
    
    func show() {
        let window = UIApplication.shared.keyWindow
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        window?.addSubview(self)
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        self.removeFromSuperview()
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        
        bgView.addSubview(tableView)
        
        bgView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(60)
            make.right.equalTo(self)
            make.size.equalTo(CGSize(width: 140, height: 150))
        }
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(bgView).offset(UIEdgeInsetsMake(kMargin, kMargin, -kMargin, 0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.isUserInteractionEnabled = true
        bgView.image = UIImage(named: "bg_menu_sort_140x46_")
        return bgView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 35
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        let nib = UINib(nibName: String(describing: SortCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: sortTableViewCellID)
        return tableView
    }()
}

extension SortTableView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sortTableViewCellID) as! SortCell
        cell.titleLabel.text = cells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sort = sorts[indexPath.row]
        delegate?.sortView(self, didSelectSortAtIndexPath: sort)
    }
}

