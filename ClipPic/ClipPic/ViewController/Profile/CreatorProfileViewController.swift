//
//  CreatorProfileViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/30.
//

import UIKit
import Kingfisher

class CreatorProfileViewController: UIViewController {
    let userId: String
    var user: User! {
        didSet {
            profileImageView.kf.setImage(with: URL(string: user.avatar))
            userNameLabel.text = "@\(user.userName)"
        }
    }
    
    var userPosts: [User.Collection] = []
    
    // MARK: - UI Properties
    
    lazy var collectionView: ProfileCollectionView = {
        let collectionView = ProfileCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        nameLabel.text = "~~~"
        return nameLabel
    }()
    
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont(name: "PingFang TC", size: 15.0)
        return userNameLabel
    }()
    
    var followersTitleLabel: UILabel = {
        let followersTitleLabel = UILabel()
        followersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        followersTitleLabel.text = "Followers"
        followersTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return followersTitleLabel
    }()
    
    var followersCountLabel: UILabel = {
        let followersCountLabel = UILabel()
        followersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        followersCountLabel.text = "100"
        followersCountLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        return followersCountLabel
    }()
    
    var totalSavedTitleLabel: UILabel = {
        let totalSavedTitleLabel = UILabel()
        totalSavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSavedTitleLabel.text = "Saved"
        totalSavedTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return totalSavedTitleLabel
    }()
    
    var totalSavedCountLabel: UILabel = {
        let totalSavedCountLabel = UILabel()
        totalSavedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalSavedCountLabel.text = "100"
        totalSavedCountLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        return totalSavedCountLabel
    }()
    
    var followButton: UIButton = {
        let followButton = UIButton()
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.backgroundColor = .label
        followButton.layer.cornerRadius = 22
        followButton.setTitleColor(.systemBackground, for: .normal)
        followButton.setTitle("Follow", for: .normal)
        return followButton
    }()
    
    lazy var postsTabButton: UIButton = {
        let postsTabButton = UIButton()
        postsTabButton.translatesAutoresizingMaskIntoConstraints = false
        postsTabButton.setTitleColor(.label, for: .normal)
        postsTabButton.setTitle("Posts", for: .normal)
        postsTabButton.addTarget(self, action: #selector(onPostsTabButtonTap), for: .touchUpInside)
        return postsTabButton
    }()
    
    lazy var savedTabButton: UIButton = {
        let savedTabButton = UIButton()
        savedTabButton.translatesAutoresizingMaskIntoConstraints = false
        savedTabButton.setTitleColor(.label, for: .normal)
        savedTabButton.setTitle("Saved", for: .normal)
        savedTabButton.addTarget(self, action: #selector(onSavedTabButtonTap), for: .touchUpInside)
        return savedTabButton
    }()

    // MARK: - Lifecyle
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpHeaderView()
        setUpGestures()
        followButton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        
        fetchProfile()
    }
    
    // MARK: - Action Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onSavedTabButtonTap() {
        collectionView.items = user.collections
    }
    
    @objc func onPostsTabButtonTap() {
        collectionView.items = userPosts
    }
    
    @objc func tapFollowButton() {
        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            print("Swipe Right")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Methods
    func fetchProfile() {
        FireStoreManager.shared.fetchProfile(userUID: userId) { user, error in
            guard let user = user else {
                print("error")
                return
            }
            self.user = user
            
            let author = Author(id: user.id, name: user.userName, avatar: user.avatar)
            FireStoreManager.shared.fetchPosts(with: author) { posts, error in
                let items = (posts ?? []).compactMap {
                    return User.Collection(id: $0.id, imageURL: $0.imageUrl)
                }
                self.userPosts = items
                self.collectionView.items = items
            }
        }
    }
    
    func setUpGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func setUpHeaderView() {
        
        view.addSubview(profileImageView)
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(totalSavedCountLabel)
        totalSavedCountLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        totalSavedCountLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 100).isActive = true
        
        view.addSubview(totalSavedTitleLabel)
        totalSavedTitleLabel.bottomAnchor.constraint(equalTo: totalSavedCountLabel.topAnchor, constant: -10).isActive = true
        totalSavedTitleLabel.centerXAnchor.constraint(equalTo: totalSavedCountLabel.centerXAnchor).isActive = true
        totalSavedTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(followersCountLabel)
        followersCountLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        followersCountLabel.leadingAnchor.constraint(equalTo: totalSavedCountLabel.trailingAnchor, constant: 70).isActive = true
        
        view.addSubview(followersTitleLabel)
        followersTitleLabel.bottomAnchor.constraint(equalTo: followersCountLabel.topAnchor, constant: -10).isActive = true
        followersTitleLabel.centerXAnchor.constraint(equalTo: followersCountLabel.centerXAnchor).isActive = true
        followersTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(followButton)
        followButton.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        followButton.leadingAnchor.constraint(equalTo: totalSavedTitleLabel.leadingAnchor).isActive = true
        followButton.trailingAnchor.constraint(equalTo: followersTitleLabel.trailingAnchor).isActive = true
        followButton.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        
        view.addSubview(tabStackView)
        tabStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        tabStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        postsTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postsTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        savedTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: postsTabButton.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    }
}

extension CreatorProfileViewController: ProfileCollectionViewDelegate {
    func didSelectItem(with postId: String) {
        let postViewController = PostViewController(with: postId)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
