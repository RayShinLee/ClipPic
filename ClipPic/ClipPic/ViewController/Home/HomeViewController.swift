//
//  ViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/14.
//

// swiftlint:disable all
import UIKit
import MJRefresh

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var fullScreenSize: CGSize!
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var header = MJRefreshStateHeader(refreshingBlock: {
        self.fetchPosts()
    })
    
    // MARK: - UI Properties
    
    lazy var homeCollectionView: PostListCollectionView = {
        let collectionView = PostListCollectionView()
        collectionView.interactionDelegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let categoryCollectionView: CategoryCollectionView = {
        let collectionView = CategoryCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var postButton: UIButton = {
        let postButton = UIButton.init(type: .custom)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setImage(UIImage(systemName: "plus"), for: .normal)
        postButton.imageView?.tintColor = .systemBackground
        return postButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        setUpViews()
        fetchPosts()
        fetchCategories()
        postButton.addTarget(self, action: #selector(tapPublishPost), for: .touchUpInside)
        
        homeCollectionView.mj_header = header
        header.lastUpdatedTimeLabel?.isHidden = true        
    }
    
    // MARK: - Action methods
    
    @objc func tapPublishPost() {
        let publishVC = PublishViewController()
        self.show(publishVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Methods
    
    func fetchPosts() {
        FireStoreManager.shared.fetchPosts(completion: { (posts, error) in
            if let error = error {
                print("Fail to fetch posts with error: \(error)")
            } else {
                self.homeCollectionView.posts = posts ?? []
            }
            self.homeCollectionView.reloadData()
            self.homeCollectionView.mj_header?.endRefreshing()
        })
    }
    
    func fetchCategories() {
        FireStoreManager.shared.fetchCategories() { (categories, error) in
            if let error = error {
                print("Fail to fetch categories with error: \(error)")
            } else {
                self.categoryCollectionView.categories = categories ?? []
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    func setUpViews() {
        view.addSubview(homeCollectionView)
        homeCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85).isActive = true
        homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.topAnchor.constraint(equalTo: homeCollectionView.bottomAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        homeCollectionView.addSubview(postButton)
        homeCollectionView.bringSubviewToFront(postButton)
        postButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        postButton.backgroundColor = .label
        postButton.layer.cornerRadius = 22
    }
}

extension HomeViewController: PostListCollectionViewDelegate, CategoryCollectionViewDelegate {
    func didSelectCategoryAt(_ categoryCollectionView: CategoryCollectionView, at index: Int) {
        
    }

    func didSelectItemAt(post: Post) {
        let postVC = PostViewController.init(with: post.id)
        self.show(postVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
}
