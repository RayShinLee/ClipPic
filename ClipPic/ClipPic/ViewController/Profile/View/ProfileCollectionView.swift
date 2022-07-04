//
//  SavedPostsCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit
import Kingfisher

protocol ProfileCollectionViewDelegate: AnyObject {
    func didSelectItem(with postId: String)
}

class ProfileCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    var items: [User.Collection] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var interactionDelegate: ProfileCollectionViewDelegate?
    
    // MARK: - View life cycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "profileCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView DataSource & Delegate
extension ProfileCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: FlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullScreenSize = UIScreen.main.bounds.size
        return CGSize(width: CGFloat(fullScreenSize.width)/2 - 8.0, height: 270)
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath)
        guard let contentCell = cell as? ProfileCollectionViewCell else {
            return cell
        }
        let itme = items[indexPath.item]
        contentCell.savedImageView.kf.setImage(with: URL(string: itme.imageURL))
        contentCell.savedImageView.contentMode = .scaleAspectFill
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId = items[indexPath.item].id
        interactionDelegate?.didSelectItem(with: postId)
    }
}
