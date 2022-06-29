//
//  SettingTableViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/29.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    var settingOptionLabel: UILabel = {
        let settingOptionLabel = UILabel()
        settingOptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingOptionLabel
    }()
    
    var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right")
        return arrowImageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func setUpView() {
        contentView.addSubview(settingOptionLabel)
        settingOptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        settingOptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        settingOptionLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9).isActive = true
        settingOptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        contentView.addSubview(arrowImageView)
        arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
