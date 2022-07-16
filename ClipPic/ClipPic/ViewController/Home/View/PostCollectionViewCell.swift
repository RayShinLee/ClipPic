//
//  ContentCollectionViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var homeImageView: UIImageView = {
        let homeImageView = UIImageView()
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.layer.cornerRadius = 20
        homeImageView.clipsToBounds = true
        return homeImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        contentView.addSubview(homeImageView)
        homeImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        homeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        homeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        homeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
