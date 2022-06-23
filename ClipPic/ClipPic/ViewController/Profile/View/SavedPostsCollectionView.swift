//
//  SavedPostsCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit
import Kingfisher

protocol SavedPostsCollectionViewDelegate: AnyObject {
    func didSelectItemAt()
}

class SavedPostsCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    weak var interactionDelegate: SavedPostsCollectionViewDelegate?
    
    // MARK: - View life cycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SavedPostsCollectionViewCell.self, forCellWithReuseIdentifier: "savedPostsCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - CollectionView DataSource & Delegate
extension SavedPostsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: CGFloat(fullScreenSize.width)/2 - 15.0, height: 200)
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedPostsCell", for: indexPath)
        guard let contentCell = cell as? SavedPostsCollectionViewCell else {
            return cell
        }
        
        contentCell.savedImageView.image = UIImage(named: "lemon")
        contentCell.savedImageView.contentMode = .scaleAspectFill
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactionDelegate?.didSelectItemAt()
    }
}
