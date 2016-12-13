//
//  HomePageCell.swift
//  Swift_Demo
//
//  Created by 周清城 on 16/9/3.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit

class HomePageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgTitle: UILabel!
    
    @IBOutlet weak var starBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.starBtn.setImage(UIImage.init(named: "PostItem_Like_18x16_"), for: UIControlState())
        self.starBtn.setImage(UIImage.init(named: "PostItem_Liked_18x16_"), for: .selected)
        self.starBtn.drawCorner(self.starBtn.frame, .allCorners, 15.0, .clear, 0.5)
        self.starBtn.titleEdgeInsets = UIEdgeInsetsMake(3.5, 18, 3.5, -1)
        self.starBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
