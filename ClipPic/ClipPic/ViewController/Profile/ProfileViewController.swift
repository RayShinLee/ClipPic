//
//  ProfileViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/20.
//

import UIKit
import SwiftUI
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .label
        backgroundView.layer.cornerRadius = 30
        return backgroundView
    }()

    var collectionView: ProfileCollectionView = {
        let collectionView = ProfileCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .label
        return collectionView
    }()
    
    lazy var tabStackView: UIStackView = {
        let tabStackView = UIStackView(arrangedSubviews: [postsTabButton, savedTabButton])
        tabStackView.translatesAutoresizingMaskIntoConstraints = false
        tabStackView.distribution  = .fillEqually
        tabStackView.alignment = .fill
        tabStackView.axis = .horizontal
        tabStackView.spacing = 5
        return tabStackView
    }()
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "Quokdog")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Rayshin Lee"
        nameLabel.font = UIFont(name: "PingFang TC", size: 20.0)
        nameLabel.textColor = .systemBackground
        return nameLabel
    }()
    
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "@rayshinlee"
        userNameLabel.font = UIFont(name: "PingFang TC", size: 15.0)
        userNameLabel.textColor = .systemBackground
        return userNameLabel
    }()
    
    var followersTitleLabel: UILabel = {
        let followersTitleLabel = UILabel()
        followersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        followersTitleLabel.text = "Followers"
        followersTitleLabel.textColor = .systemBackground
        return followersTitleLabel
    }()
    
    var followersCountLabel: UILabel = {
        let followersCountLabel = UILabel()
        followersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        followersCountLabel.text = "100"
        followersCountLabel.textColor = .systemBackground
        return followersCountLabel
    }()
    
    var totalSavedTitleLabel: UILabel = {
        let totalSavedTitleLabel = UILabel()
        totalSavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSavedTitleLabel.text = "Saved"
        totalSavedTitleLabel.textColor = .systemBackground
        return totalSavedTitleLabel
    }()
    
    var totalSavedCountLabel: UILabel = {
        let totalSavedCountLabel = UILabel()
        totalSavedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSavedCountLabel.text = "100"
        totalSavedCountLabel.textColor = .systemBackground
        return totalSavedCountLabel
    }()
    
    var postsTabButton: UIButton = {
        let postsTabButton = UIButton()
        postsTabButton.translatesAutoresizingMaskIntoConstraints = false
        postsTabButton.setTitleColor(.systemBackground, for: .normal)
        postsTabButton.setTitle("Posts", for: .normal)
        return postsTabButton
    }()
    
    var savedTabButton: UIButton = {
        let savedTabButton = UIButton()
        savedTabButton.translatesAutoresizingMaskIntoConstraints = false
        savedTabButton.setTitleColor(.systemBackground, for: .normal)
        savedTabButton.setTitle("Saved", for: .normal)
        return savedTabButton
    }()
    
    var settingsButton: UIButton = {
        let settingsButton = UIButton(type: .custom)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let imageSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let image = UIImage(systemName: "gearshape",
                            withConfiguration: imageSize)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        settingsButton.setImage(image, for: .normal)
        settingsButton.imageView?.tintColor = .label
        return settingsButton
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        settingsButton.addTarget(self, action: #selector(tapSettingsButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Action Methods
    
    @objc func tapSettingsButton() {
        self.show(SettingsViewController(), sender: nil)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Methods
    
    func setUpView() {
        view.addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85).isActive = true
        
        setUpHeaderView()
        setUpCollectionView()
    }
    
    func setUpHeaderView() {
        view.addSubview(settingsButton)
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        backgroundView.addSubview(profileImageView)
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -40).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        backgroundView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(totalSavedCountLabel)
        totalSavedCountLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 7).isActive = true
        totalSavedCountLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 100).isActive = true
        
        backgroundView.addSubview(totalSavedTitleLabel)
        totalSavedTitleLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.bottomAnchor, constant: 5).isActive = true
        totalSavedTitleLabel.centerXAnchor.constraint(equalTo: totalSavedCountLabel.centerXAnchor).isActive = true
        totalSavedTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(followersCountLabel)
        followersCountLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.topAnchor).isActive = true
        followersCountLabel.leadingAnchor.constraint(equalTo: totalSavedCountLabel.trailingAnchor, constant: 70).isActive = true
        
        backgroundView.addSubview(followersTitleLabel)
        followersTitleLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 5).isActive = true
        followersTitleLabel.centerXAnchor.constraint(equalTo: followersCountLabel.centerXAnchor).isActive = true
        followersTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setUpCollectionView() {
        
        backgroundView.addSubview(tabStackView)
        tabStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        tabStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        tabStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        
        postsTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postsTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        savedTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: postsTabButton.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    }
}

extension ProfileViewController: ProfileCollectionViewDelegate {
    func didSelectItemAt() { // postId
        //  self.show(PostViewController(), sender: nil)
    }
}
