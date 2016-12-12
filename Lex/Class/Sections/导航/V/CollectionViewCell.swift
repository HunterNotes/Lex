//
//  CollectionViewCell.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

import Kingfisher

protocol CollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidClickedLikeButton(_ button: UIButton)
}

class YMCollectionViewCell: UICollectionViewCell {
    
    // 占位图片
    @IBOutlet weak var placeholderBtn: UIButton!
    // 背景图片
    @IBOutlet weak var productImageView: UIImageView!
    // 标题
    @IBOutlet weak var titleLabel: UILabel!
    // 价格
    @IBOutlet weak var priceLabel: UILabel!
    // 喜欢按钮
    @IBOutlet weak var likeButton: UIButton!

    weak var delegate: CollectionViewCellDelegate?
    
    var result: SearchResult? {
        didSet {
            let url = result!.cover_image_url!
            productImageView.kf.setImage(with: URL(string: url)!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.placeholderBtn.isHidden = true
            })
            
            likeButton.setTitle(" " + String(result!.favorites_count!) + " ", for: UIControlState())
            titleLabel.text = result!.name
            priceLabel.text = "￥" + String(result!.price!)
        }
    }
    
    
    var product: Product? {
        didSet {
            let url = product!.cover_image_url!
            productImageView.kf.setImage(with: URL(string: url)!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.placeholderBtn.isHidden = true
            })
            
            likeButton.setTitle(" " + String(product!.favorites_count!) + " ", for: UIControlState())
            titleLabel.text = product!.name
            priceLabel.text = "￥" + String(product!.price!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func likeButtonClick(_ sender: UIButton) {
        delegate?.collectionViewCellDidClickedLikeButton(sender)
    }
}
