//
//  GenderCell.swift
//  Lex
//
//  Created by nbcb on 2017/1/12.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {

    @IBOutlet weak var genderLab: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
