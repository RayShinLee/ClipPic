//
//  SavedPostsCollectionViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var savedImageView: UIImageView = {
        let savedImageView = UIImageView()
        savedImageView.translatesAutoresizingMaskIntoConstraints = false
        savedImageView.layer.cornerRadius = 20
        savedImageView.clipsToBounds = true
        return savedImageView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        self.addSubview(savedImageView)
        savedImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        savedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        savedImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        savedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
