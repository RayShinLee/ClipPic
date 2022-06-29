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

    var recentSavedCollectionView: SavedPostsCollectionView = {
        let recentSavedCollectionView = SavedPostsCollectionView()
        recentSavedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentSavedCollectionView.backgroundColor = .label
        return recentSavedCollectionView
    }()
    
    var allSavedCollectionView: SavedPostsCollectionView = {
        let allSavedCollectionView = SavedPostsCollectionView()
        allSavedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        allSavedCollectionView.backgroundColor = .label
        return allSavedCollectionView
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
    
    var recentSavedLabel: UILabel = {
        let recentSavesLabel = UILabel()
        recentSavesLabel.translatesAutoresizingMaskIntoConstraints = false
        recentSavesLabel.text = "Recent Saves"
        recentSavesLabel.font = UIFont(name: "PingFang TC", size: 20.0)
        recentSavesLabel.textColor = .systemBackground
        return recentSavesLabel
    }()
    
    var allSavedLabel: UILabel = {
        let allSavedLabel = UILabel()
        allSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        allSavedLabel.text = "All Saved"
        allSavedLabel.font = UIFont(name: "PingFang TC", size: 20.0)
        allSavedLabel.textColor = .systemBackground
        return allSavedLabel
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
    
    var signOutButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = .systemPink
        return signOutButton
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        settingsButton.addTarget(self, action: #selector(tapSettingsButton), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(tapSignOutButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Action Methods
    
    @objc func tapSettingsButton() {
        self.show(SettingsViewController(), sender: nil)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func tapSignOutButton() {
        AccountManager.shared.signOut()
    }
    
    // MARK: - Methods
    
    func setUpView() {
        view.addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = true
        
        setUpHeaderView()
        setUpCollectionView()
    }
    
    func setUpHeaderView() {
        view.addSubview(settingsButton)
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(signOutButton)
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        backgroundView.addSubview(recentSavedLabel)
        recentSavedLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        recentSavedLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        
        backgroundView.addSubview(recentSavedCollectionView)
        recentSavedCollectionView.topAnchor.constraint(equalTo: recentSavedLabel.bottomAnchor).isActive = true
        recentSavedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentSavedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recentSavedCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        backgroundView.addSubview(allSavedLabel)
        allSavedLabel.topAnchor.constraint(equalTo: recentSavedCollectionView.bottomAnchor, constant: 5).isActive = true
        allSavedLabel.leadingAnchor.constraint(equalTo: recentSavedLabel.leadingAnchor).isActive = true

        backgroundView.addSubview(allSavedCollectionView)
        allSavedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        allSavedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        allSavedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        allSavedCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
    }
}
