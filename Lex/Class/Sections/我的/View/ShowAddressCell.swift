//
//  ShowAddressCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/21.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class ShowAddressCell: UITableViewCell {

    @IBOutlet weak var userLab: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var editAddressBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
