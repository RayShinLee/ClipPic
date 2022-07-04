//
//  EditProfileTableViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/4.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
    // MARK: - UI properties
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemBackground
        return separatorView
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
        addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        addSubview(nameTextField)
        nameTextField.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        
        addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }

}
