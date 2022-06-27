//
//  SeachResultCollectionViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var searchResultItemView: UIView = {
        let searchResultItemView = UIView()
        searchResultItemView.translatesAutoresizingMaskIntoConstraints = false
        searchResultItemView.backgroundColor = .label
        return searchResultItemView
    }()
    
    var searchResultImageView: UIImageView = {
        let searchResultImageView = UIImageView()
        searchResultImageView.translatesAutoresizingMaskIntoConstraints = false
        searchResultImageView.contentMode = .scaleAspectFill
        //  searchResultImageView.layer.cornerRadius = 20
        searchResultImageView.clipsToBounds = true
        return searchResultImageView
    }()

    var searchResultTitleLabel: UILabel = {
        let searchResultTitleLabel = UILabel()
        searchResultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchResultTitleLabel.lineBreakMode = .byWordWrapping
        searchResultTitleLabel.numberOfLines = 0
        searchResultTitleLabel.textColor = .systemBackground
        searchResultTitleLabel.font = UIFont(name: "PingFang TC", size: 15.0)
        return searchResultTitleLabel
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
        
        self.addSubview(searchResultItemView)
        searchResultItemView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchResultItemView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        searchResultItemView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchResultItemView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        searchResultItemView.addSubview(searchResultImageView)
        searchResultImageView.topAnchor.constraint(equalTo: searchResultItemView.topAnchor, constant: 5).isActive = true
        searchResultImageView.centerXAnchor.constraint(equalTo: searchResultItemView.centerXAnchor).isActive = true
        searchResultImageView.widthAnchor.constraint(equalTo: searchResultItemView.widthAnchor, multiplier: 0.95).isActive = true
        searchResultImageView.heightAnchor.constraint(equalTo: searchResultItemView.heightAnchor, multiplier: 0.7).isActive = true
        
        searchResultItemView.addSubview(searchResultTitleLabel)
        searchResultTitleLabel.topAnchor.constraint(equalTo: searchResultImageView.bottomAnchor, constant: 5).isActive = true
        searchResultTitleLabel.bottomAnchor.constraint(equalTo: searchResultItemView.bottomAnchor, constant: -2).isActive = true
        searchResultTitleLabel.leadingAnchor.constraint(equalTo: searchResultItemView.leadingAnchor, constant: 5).isActive = true
        searchResultTitleLabel.trailingAnchor.constraint(equalTo: searchResultItemView.trailingAnchor, constant: -5).isActive = true

    }
}
