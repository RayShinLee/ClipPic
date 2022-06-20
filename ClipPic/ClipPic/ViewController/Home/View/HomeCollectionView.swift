//
//  HomeCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import UIKit

protocol HomeCollectionViewDelegate: AnyObject {
    func didSelectItemAt(at index: IndexPath)
}

class HomeCollectionView: UICollectionView {
    weak var interactionDelegate: HomeCollectionViewDelegate?
    
    // MARK: View life cycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - CollectionView DataSource & Delegate
extension HomeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: FlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullScreenSize = UIScreen.main.bounds.size
        return CGSize(width: CGFloat(fullScreenSize.width)/2 - 15.0, height: 300)
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
        guard let contentCell = cell as? ContentCollectionViewCell else {
            return cell
        }
        contentCell.homeImageView.image = UIImage(named: "lemon")
        contentCell.homeImageView.contentMode = .scaleAspectFill
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactionDelegate?.didSelectItemAt(at: indexPath)
    }
}
