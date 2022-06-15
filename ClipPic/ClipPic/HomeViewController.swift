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
    
    private let homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setUpCollectionView()
    }
    
    // MARK: - methods
    
    func setUpCollectionView() {
        view.addSubview(homeCollectionView)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .white
        homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    /*
    func setUpImageCollectionView() {
        fullScreenSize = UIScreen.main.bounds.size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        // layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/2 - 15.0,
            height: CGFloat(fullScreenSize.width)/2 - 5.0)
        layout.scrollDirection = .vertical
        
        let homeCollectionView = UICollectionView(frame: CGRect(
              x: 0, y: 20,
              width: fullScreenSize.width,
              height: fullScreenSize.height - 50),
            collectionViewLayout: layout)
        
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        self.view.addSubview(homeCollectionView)
    } */
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        fullScreenSize = UIScreen.main.bounds.size

        if indexPath.section == 0 {
            return CGSize(
                width: CGFloat(fullScreenSize.width)/2 - 15.0,
                height: CGFloat(fullScreenSize.width)/2 - 5.0)
        } else {
            return CGSize(
                width: CGFloat(fullScreenSize.width)/4,
                height: 50)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 10 // count of posts
        } else {
            return 5 // count of categories
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            switch indexPath.section {
            case 0:
                let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
                
                guard let contentCell = imageCell as? ContentCollectionViewCell else {
                    return imageCell
                }
                contentCell.backgroundColor = .blue
                contentCell.layer.cornerRadius = 20
                return contentCell
            case 1:
                let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
                guard let category = categoryCell as? HomeCategoryCollectionViewCell else {
                    return categoryCell
                }
                category.categoryTitle?.text = "LifeStyle"
                category.backgroundColor = .gray
                category.layer.cornerRadius = 20
                return category
            default:
                assert(false)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = ImageViewController()
        self.show(imageVC, sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
}
