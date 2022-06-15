//
//  ViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/14.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var fullScreenSize: CGSize!
    
    // MARK: - UI Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    // MARK: - methods
    
    func setUpCollectionView() {
        fullScreenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        // layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/2 - 15.0,
            height: CGFloat(fullScreenSize.width)/2 - 5.0)
        layout.scrollDirection = .vertical
        
        let homeCollectionView = UICollectionView(frame: CGRect(
              x: 0, y: 20,
              width: fullScreenSize.width,
              height: fullScreenSize.height - 20),
            collectionViewLayout: layout)
        
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")

        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self

        self.view.addSubview(homeCollectionView)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
     */
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // count of posts
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
        contentCell.backgroundColor = UIColor.blue
        contentCell.layer.cornerRadius = 20
        
        return contentCell
    }
}

extension HomeViewController: UICollectionViewDelegate {
}
