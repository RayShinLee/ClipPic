//
//  ProfileViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/20.
//

import UIKit
import SwiftUI

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
    
    var savedPostsCollectionView: PostListCollectionView = {
        let savedPostsCollectionView = PostListCollectionView()
        savedPostsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        savedPostsCollectionView.backgroundColor = .label
        return savedPostsCollectionView
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
        nameLabel.textColor = .systemBackground
        return nameLabel
    }()
    
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "@rayshinlee"
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
    
    var settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.tintColor = .label
        settingsButton.imageView?.image = UIImage(systemName: "gearshape")
        return settingsButton
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
    }
    
    // MARK: - Action Methods
    
    @objc func tapSettingsButton() {
        self.show(SettingsViewController(), sender: nil)
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
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
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
        totalSavedCountLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 50).isActive = true
        
        backgroundView.addSubview(totalSavedTitleLabel)
        totalSavedTitleLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.bottomAnchor, constant: 5).isActive = true
        totalSavedTitleLabel.centerXAnchor.constraint(equalTo: totalSavedCountLabel.centerXAnchor).isActive = true
        totalSavedTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(followersCountLabel)
        followersCountLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.topAnchor).isActive = true
        followersCountLabel.leadingAnchor.constraint(equalTo: totalSavedCountLabel.trailingAnchor, constant: 100).isActive = true
        
        backgroundView.addSubview(followersTitleLabel)
        followersTitleLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 5).isActive = true
        followersTitleLabel.centerXAnchor.constraint(equalTo: followersCountLabel.centerXAnchor).isActive = true
        followersTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setUpCollectionView() {
        backgroundView.addSubview(savedPostsCollectionView)
        savedPostsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        savedPostsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        savedPostsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        savedPostsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }
}
