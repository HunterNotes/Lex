//
//  DetectionCell.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/10/9.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class DetectionCell: UITableViewCell {
    
    var headImgView         :UIImageView!
    var nameLabel           :UILabel!
    var IdLabel             :UILabel!
    var moneyLabel          :UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ model:DetectionModel){
        for subviews in self.contentView.subviews {
            subviews.removeFromSuperview()
        }
        
        self.headImgView = UIImageView(image: UIImage(named: "IMG_6"))
        self.contentView.addSubview(self.headImgView)
        self.headImgView.frame = CGRect.init(x: 10, y: 10, width: 100, height: 100)
        
        self.nameLabel = UILabel(frame: CGRect(x: 120, y: 10, width: self.contentView.frame.size.width - 100, height: 30))
        self.nameLabel.text = "名字:\(model.name)"
        self.contentView.addSubview(self.nameLabel)
        
        
        self.IdLabel = UILabel(frame: CGRect.init(x: 120, y: 40, width: self.contentView.frame.size.width - 100, height: 30))
        self.IdLabel.text = "编号：\(model.ID)"
        self.contentView.addSubview(self.IdLabel)
        
        self.moneyLabel=UILabel(frame:CGRect.init(x: 120, y: 70, width: self.contentView.frame.size.width - 100, height: 30))
        self.moneyLabel.text="价格：\(model.money)"
        self.contentView.addSubview(self.moneyLabel)
    }
}
