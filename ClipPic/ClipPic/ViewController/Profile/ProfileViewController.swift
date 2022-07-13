//
//  ProfileViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/20.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    var userPosts: [User.Collection] = []
    
    // MARK: - UI Properties
    
    var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .label
        backgroundView.layer.cornerRadius = 30
        return backgroundView
    }()

    lazy var collectionView: ProfileCollectionView = {
        let collectionView = ProfileCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .label
        collectionView.interactionDelegate = self
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
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "PingFang TC", size: 20.0)
        nameLabel.textColor = .systemBackground
        return nameLabel
    }()
    
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
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
        totalSavedCountLabel.textColor = .systemBackground
        return totalSavedCountLabel
    }()
    
    lazy var postsTabButton: UIButton = {
        let postsTabButton = UIButton()
        postsTabButton.translatesAutoresizingMaskIntoConstraints = false
        postsTabButton.layer.cornerRadius = 20
        postsTabButton.setTitle("Posts", for: .normal)
        postsTabButton.addTarget(self, action: #selector(onPostsTabButtonTap), for: .touchUpInside)
        return postsTabButton
    }()
    
    lazy var savedTabButton: UIButton = {
        let savedTabButton = UIButton()
        savedTabButton.translatesAutoresizingMaskIntoConstraints = false
        savedTabButton.layer.cornerRadius = 20
        savedTabButton.setTitle("Saved", for: .normal)
        savedTabButton.addTarget(self, action: #selector(onSavedTabButtonTap), for: .touchUpInside)
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
        settingsButton.addTarget(self, action: #selector(tapSettingsButton), for: .touchUpInside)
        return settingsButton
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        refresh()
        fetchFollowersCount()
        
        // to adjust
        postsTabButton.backgroundColor = .systemBackground
        postsTabButton.setTitleColor(.label, for: .normal)
        savedTabButton.setTitleColor(.systemBackground, for: .normal)
        collectionView.reloadData()
    }
    
    // MARK: - Action Methods
    
    @objc func tapSettingsButton() {
        self.show(SettingsViewController(), sender: nil)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func onSavedTabButtonTap() {
        savedTabButton.backgroundColor = .systemBackground
        savedTabButton.setTitleColor(.label, for: .normal)
        postsTabButton.backgroundColor = .clear
        postsTabButton.setTitleColor(.systemBackground, for: .normal)
        collectionView.items = AccountManager.shared.appUser?.collections ?? []
    }
    
    @objc func onPostsTabButtonTap() {
        postsTabButton.backgroundColor = .systemBackground
        postsTabButton.setTitleColor(.label, for: .normal)
        savedTabButton.backgroundColor = .clear
        savedTabButton.setTitleColor(.systemBackground, for: .normal)
        collectionView.items = userPosts
    }
    
    // MARK: - Methods
    func refresh() {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        print(user.avatar)
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        userNameLabel.text = "@\(user.userName)"
        profileImageView.kf.setImage(with: URL(string: user.avatar))
        totalSavedCountLabel.text = "\(user.collections.count)"
    }
    
    func fetchPosts() {
        guard let user = AccountManager.shared.appUser else { return }
        let author = SimpleUser(id: user.id, name: user.userName, avatar: user.avatar)
        FireStoreManager.shared.fetchPosts(with: author) { posts, error in
            let items = (posts ?? []).compactMap {
                return User.Collection(id: $0.id, imageURL: $0.imageUrl)
            }
            self.userPosts = items
            self.collectionView.items = items
        }
    }
    
    func fetchFollowersCount() {
        FireStoreManager.shared.fetchMyFollowersCount { count in
            self.followersCountLabel.text = "\(count)"
        }
    }
    
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
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        backgroundView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(totalSavedCountLabel)
        totalSavedCountLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 7).isActive = true
        
        backgroundView.addSubview(followersCountLabel)
        followersCountLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.topAnchor).isActive = true
        followersCountLabel.leadingAnchor.constraint(equalTo: totalSavedCountLabel.trailingAnchor, constant: 100).isActive = true
        followersCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80).isActive = true
        
        backgroundView.addSubview(totalSavedTitleLabel)
        totalSavedTitleLabel.topAnchor.constraint(equalTo: totalSavedCountLabel.bottomAnchor, constant: 5).isActive = true
        totalSavedTitleLabel.centerXAnchor.constraint(equalTo: totalSavedCountLabel.centerXAnchor).isActive = true
        totalSavedTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundView.addSubview(followersTitleLabel)
        followersTitleLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 5).isActive = true
        followersTitleLabel.centerXAnchor.constraint(equalTo: followersCountLabel.centerXAnchor).isActive = true
        followersTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setUpCollectionView() {
        backgroundView.addSubview(tabStackView)
        tabStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        tabStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5).isActive = true
        tabStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5).isActive = true
        
        postsTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postsTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        savedTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: postsTabButton.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    }
}

extension ProfileViewController: ProfileCollectionViewDelegate {
    func didSelectItem(with postId: String) {
        let postViewController = PostViewController(with: postId)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
