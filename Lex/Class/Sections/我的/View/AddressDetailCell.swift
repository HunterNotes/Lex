//
//  AddressDetailCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/21.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import RETableViewManager

class AddressDetailCell: UITableViewCell {

    @IBOutlet weak var leftLab: UILabel!
    @IBOutlet weak var textView: REPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView.placeholderColor = globalBGColor()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
