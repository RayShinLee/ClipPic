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
    
    // MARK: - UI Properties
    
    lazy var homeCollectionView: HomeCollectionView = {
        let collectionView = HomeCollectionView()
        collectionView.interactionDelegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        postButton.backgroundColor = .lightGray
        postButton.layer.cornerRadius = 22
    }
    
    @objc func tapPublishPost() {
        let publishVC = PublishViewController()
        self.show(publishVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        fullScreenSize = UIScreen.main.bounds.size
        return CGSize(width: CGFloat(fullScreenSize.width)/3, height: 30)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // count of categories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
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

extension HomeViewController: HomeCollectionViewDelegate {
    func didSelectItemAt(at index: IndexPath) {
        let imageVC = ImageViewController()
        self.show(imageVC, sender: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
}
