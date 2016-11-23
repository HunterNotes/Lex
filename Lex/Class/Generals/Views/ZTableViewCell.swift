//
//  TableViewCell.swift
//  Swift Demo
//
//  Created by nbcb on 16/3/25.
//  Copyright © 2016年 Synjones. All rights reserved.
//

import UIKit

class ZTableViewCell: UITableViewCell {

    @IBOutlet weak var leftlabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var starBtn: UIButton!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.starBtn.setImage(UIImage(named: "Post_FavoriteButton_50x50_"), for: UIControlState())
        self.starBtn.setImage(UIImage(named: "Post_FavoriteButton_Highlighted_50x50_"), for: .highlighted)
        self.starBtn.setImage(UIImage(named: "Post_FavoriteButton_Selected_50x50_"), for: .selected)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
