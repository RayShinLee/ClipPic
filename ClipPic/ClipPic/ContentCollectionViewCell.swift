//
//  ContentCollectionViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = Double(UIScreen.main.bounds.size.width)
        
        imageView = UIImageView(frame: CGRect(
            x: 0, y: 0,
            width: width/3 - 10.0, height: width/3 - 10.0))

        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
