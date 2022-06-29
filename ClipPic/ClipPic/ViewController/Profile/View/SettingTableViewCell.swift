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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
        setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods

    func setUpView() {
        self.addSubview(settingOptionLabel)
        settingOptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingOptionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
        settingOptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        self.addSubview(arrowImageView)
        arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowImageView.heightAnchor.constraint(equalTo: settingOptionLabel.heightAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
    }
}
