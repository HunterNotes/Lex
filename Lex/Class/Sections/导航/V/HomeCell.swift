//
//  HomeCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeCellDelegate: NSObjectProtocol {
    
    func homeCellDidClickedFavoriteButton(_ button: UIButton)
}

class HomeCell: UITableViewCell {
    
    weak var delegate: HomeCellDelegate?
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var placeholderBtn: UIButton!
    
    var homeItem: HomeItem? {
        didSet {
            let url = homeItem!.cover_image_url
            bgImageView.kf.setImage(with: URL.init(fileURLWithPath: url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.placeholderBtn.isHidden = true
            })
        
            titleLabel.text = homeItem!.title
            favoriteBtn.setTitle(" " + String(homeItem!.likes_count!) + " ", for: UIControlState())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteBtn.drawCorner(favoriteBtn.frame, .allCorners, favoriteBtn.height * 0.5, .orange, 0.5)
//        favoriteBtn.layer.cornerRadius = favoriteBtn.height * 0.5
//        favoriteBtn.layer.masksToBounds = true
//        favoriteBtn.layer.rasterizationScale = UIScreen.main.scale
//        favoriteBtn.layer.shouldRasterize = true
//        bgImageView.layer.cornerRadius = kCornerRadius
//        bgImageView.layer.masksToBounds = true
//        bgImageView.layer.shouldRasterize = true
//        bgImageView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// 点击了喜欢按钮
    @IBAction func favoriteButtonClick(_ sender: UIButton) {
        delegate?.homeCellDidClickedFavoriteButton(sender)
    }
}
