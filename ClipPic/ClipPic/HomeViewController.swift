//
//  ViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/14.
//

// swiftlint:disable all
import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var fullScreenSize: CGSize!
    let layout = UICollectionViewFlowLayout()
    let category = [
        CategoryModel(categoryTitle: "For you"),
        CategoryModel(categoryTitle: "LifeStyle"),
        CategoryModel(categoryTitle: "Beauty"),
        CategoryModel(categoryTitle: "Home"),
        CategoryModel(categoryTitle: "Places"),
    ]
    
    // MARK: - UI Properties
    
    private let homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
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
        postButton.addTarget(self, action: #selector(tapPublishPost), for: .touchUpInside)
    }
    
    // MARK: - methods
    
    func setUpViews() {
        view.addSubview(homeCollectionView)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85).isActive = true
        homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.topAnchor.constraint(equalTo: homeCollectionView.bottomAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        homeCollectionView.addSubview(postButton)
        homeCollectionView.bringSubviewToFront(postButton)
        postButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        postButton.backgroundColor = .lightGray
        postButton.layer.cornerRadius = 22
    }
    
    @objc func tapPublishPost() {
        let publishVC = PublishViewController()
        self.show(publishVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.homeCollectionView {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 3, left: 10, bottom: 5, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        fullScreenSize = UIScreen.main.bounds.size

        if collectionView == self.homeCollectionView {
            return CGSize(
                width: CGFloat(fullScreenSize.width)/2 - 15.0,
                height: 300) // CGFloat(fullScreenSize.width)/2 - 5.0)
        } else {
            return CGSize(
                width: CGFloat(fullScreenSize.width)/3,
                height: 30)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.homeCollectionView {
            return 10 // count of posts
        } else {
            return category.count // count of categories
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        if collectionView == self.homeCollectionView {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
            guard let contentCell = imageCell as? ContentCollectionViewCell else {
                return imageCell
            }
            contentCell.homeImageView.image = UIImage(named: "lemon")
            contentCell.homeImageView.contentMode = .scaleAspectFill
            contentCell.layer.cornerRadius = 20
            return contentCell
        } else {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
            guard let category = categoryCell as? HomeCategoryCollectionViewCell else {
                return categoryCell
            }
            category.categoryTitle?.text = "Category"
            category.backgroundColor = .gray
            category.layer.cornerRadius = 10
            return category
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = ImageViewController()
        self.show(imageVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension HomeViewController: UICollectionViewDelegate {
}
