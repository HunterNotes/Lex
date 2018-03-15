//
//  EditAddressCommonCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/21.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class EditAddressCommonCell: UITableViewCell {

    @IBOutlet weak var leftLab: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.button.imageEdgeInsets = UIEdgeInsets.init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
