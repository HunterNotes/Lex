//
//  PicListCollectionView.swift
//  Lex
//
//  Created by nbcb on 2017/3/17.
//  Copyright © 2017年 ZQC. All rights reserved.
//

import UIKit

private let picListCellID = "PicListCell"

class PicListCollectionView: UICollectionView {
    
    var selPicBlock : SeletedPicBlock?
    
    var imgArr = [UIImage]() {
        
        didSet {
            self.reloadData()
            scrollToBottom()
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(2.5 , 2.5, 2.5, 2.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func scrollToBottom() {
        
        if self.imgArr.count < 1 { return } else {
            let lastIndexPath = NSIndexPath(item: self.imgArr.count-1, section: 0)
            
            self.scrollToItem(at: lastIndexPath as IndexPath, at: .right, animated: true)
        }
    }
}

// MARK:- UICollectionViewDataSource UICollectionViewDelegate UICollectionViewDelegateFlowLayout
extension PicListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picListCellID, for: indexPath) as! PicListCell
        cell.imgView.image = imgArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item : Int = (indexPath as NSIndexPath).item
        
        if (self.selPicBlock) != nil {
            self.selPicBlock!(self.imgArr[item])
        }
    }
}

