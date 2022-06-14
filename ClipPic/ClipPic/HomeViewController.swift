//
//  ViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/14.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    var homeCollectionView: UICollectionView?
    
    //MARK: - UI Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionView
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        homeCollectionView?.dataSource = self
        homeCollectionView?.delegate = self
        homeCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
    }
    
    //MARK: - methods
    
    func setUpCollectionView() {
        
        guard let homeCollectionView = homeCollectionView else {
            return
        }
        
        view.addSubview(homeCollectionView)
        homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //count of posts
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
        contentCell.backgroundColor = UIColor.blue
        return contentCell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}
