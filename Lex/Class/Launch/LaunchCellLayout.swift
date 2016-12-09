//
//  LaunchCellLayout.swift
//  Lex
//
//  Created by nbcb on 2016/12/9.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class LaunchCellLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        // 设置 layout 布局
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 设置 contentView 属性
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
