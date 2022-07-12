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
            totalSavedCountLabel.text = "\(user.collections.count)"
            nameLabel.text = "\(user.firstName) \(user.lastName)"
        }
    }
    
    var userPosts: [User.Collection] = []
    var post: Post!
    
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
        followersCountLabel.text = "0"
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
        totalSavedCountLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        return totalSavedCountLabel
    }()
    
    lazy var followButton: UIButton = {
        let followButton = UIButton()
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.backgroundColor = .label
        followButton.layer.cornerRadius = 22
        followButton.setTitleColor(.systemBackground, for: .normal)
        followButton.setTitle("Follow", for: .normal)
        followButton.isHidden = (AccountManager.shared.appUser?.id == userId)
        return followButton
    }()
    
    lazy var seeMoreButton: UIButton = {
        let seeMoreButton = UIButton()
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        seeMoreButton.isHidden = (AccountManager.shared.appUser?.id == userId)
        seeMoreButton.addTarget(self, action: #selector(tapSeeMoreButton), for: .touchUpInside)
        return seeMoreButton
    }()
    
    lazy var postsTabButton: UIButton = {
        let postsTabButton = UIButton()
        postsTabButton.translatesAutoresizingMaskIntoConstraints = false
        postsTabButton.layer.cornerRadius = 22
        postsTabButton.setTitle("Posts", for: .normal)
        postsTabButton.addTarget(self, action: #selector(onPostsTabButtonTap), for: .touchUpInside)
        return postsTabButton
    }()
    
    lazy var savedTabButton: UIButton = {
        let savedTabButton = UIButton()
        savedTabButton.translatesAutoresizingMaskIntoConstraints = false
        savedTabButton.layer.cornerRadius = 22
        savedTabButton.setTitle("Saved", for: .normal)
        savedTabButton.addTarget(self, action: #selector(onSavedTabButtonTap), for: .touchUpInside)
        return savedTabButton
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.imageView?.tintColor = .label
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return backButton
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        postsTabButton.backgroundColor = .label
        postsTabButton.setTitleColor(.systemBackground, for: .normal)
        savedTabButton.setTitleColor(.label, for: .normal)
        collectionView.reloadData()
    }
    
    // MARK: - Action Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapSeeMoreButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let xOrigin = view.bounds.width / 2
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = popoverRect
        alert.popoverPresentationController?.permittedArrowDirections = .up
        alert.addAction(UIAlertAction(title: "Block user", style: .destructive) { _ in
            let user = SimpleUser(id: self.user.id, name: self.user.userName, avatar: self.user.avatar)
            ClipPicProgressHUD.show()
            FireStoreManager.shared.blockUser(blockedUser: user) { error in
                if let error = error {
                    print(error)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                ClipPicProgressHUD.hide()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func onSavedTabButtonTap() {
        savedTabButton.backgroundColor = .label
        savedTabButton.setTitleColor(.systemBackground, for: .normal)
        postsTabButton.backgroundColor = .clear
        postsTabButton.setTitleColor(.label, for: .normal)
        collectionView.items = user.collections
    }
    
    @objc func onPostsTabButtonTap() {
        postsTabButton.backgroundColor = .label
        postsTabButton.setTitleColor(.systemBackground, for: .normal)
        savedTabButton.backgroundColor = .clear
        savedTabButton.setTitleColor(.label, for: .normal)
        collectionView.items = userPosts
    }
    
    @objc func tapFollowButton() {
        let simpleUser = SimpleUser(id: post.author.id, name: post.author.name, avatar: post.author.avatar)
        FireStoreManager.shared.followAccount(followedAccount: simpleUser) { error in
            if let error = error {
                print(error)
            } else {
                self.updateFollowButton()
            }
        }
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
            
            let author = SimpleUser(id: user.id, name: user.userName, avatar: user.avatar)
            FireStoreManager.shared.fetchPosts(with: author) { posts, error in
                let items = (posts ?? []).compactMap {
                    return User.Collection(id: $0.id, imageURL: $0.imageUrl)
                }
                self.userPosts = items
                self.collectionView.items = items
            }
        }
    }
    
    private func updateFollowButton() {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        self.followButton.isHidden = (post.author.id == user.id)
        
        if user.followedAccounts.contains(where: { $0.id == post.author.id }) {
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
    func setUpGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func setUpHeaderView() {
        view.addSubview(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(profileImageView)
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
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
        
        /*
        view.addSubview(followButton)
        followButton.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        followButton.leadingAnchor.constraint(equalTo: totalSavedTitleLabel.leadingAnchor).isActive = true
        followButton.trailingAnchor.constraint(equalTo: followersTitleLabel.centerXAnchor).isActive = true
        followButton.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
         */
        view.addSubview(seeMoreButton)
        seeMoreButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        seeMoreButton.trailingAnchor.constraint(equalTo: followersTitleLabel.trailingAnchor).isActive = true
        
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        
        view.addSubview(tabStackView)
        tabStackView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        tabStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        tabStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        
        postsTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postsTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedTabButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        savedTabButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: postsTabButton.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.57).isActive = true
    }
}

extension CreatorProfileViewController: ProfileCollectionViewDelegate {
    func didSelectItem(with postId: String) {
        let postViewController = PostViewController(with: postId)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
