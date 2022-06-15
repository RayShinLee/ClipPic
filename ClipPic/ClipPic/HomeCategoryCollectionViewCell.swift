//
//  HomeCategoryCollectionViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    
    var categoryTitle: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
