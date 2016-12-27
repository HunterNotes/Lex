//
//  LocationCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/27.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var mark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
