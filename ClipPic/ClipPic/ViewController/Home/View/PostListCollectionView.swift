//
//  HomeCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import UIKit
import Kingfisher

protocol PostListCollectionViewDelegate: AnyObject {
    func didSelectItemAt(post: Post)
}

class PostListCollectionView: UICollectionView {
    
    weak var interactionDelegate: PostListCollectionViewDelegate?
    var posts: [Post] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - View life cycle
    init() {
        let waterFallLayout = WaterFallFlowLayout()
        waterFallLayout.minimumLineSpacing = 15
        waterFallLayout.minimumInteritemSpacing = 15
        waterFallLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init(frame: .zero, collectionViewLayout: waterFallLayout)
        waterFallLayout.delegate = self
        
        register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView DataSource & Delegate
extension PostListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
        guard let contentCell = cell as? PostCollectionViewCell else {
            return cell
        }
        
        let postImage = posts[indexPath.item]
        contentCell.homeImageView.kf.setImage(with: URL(string: postImage.imageUrl),
                                              placeholder: nil,
                                              options: [.cacheOriginalImage],
                                              completionHandler: nil)
        contentCell.homeImageView.kf.setImage(with: URL(string: postImage.imageUrl))
        contentCell.homeImageView.contentMode = .scaleAspectFill
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactionDelegate?.didSelectItemAt(post: posts[indexPath.item])
    }
}

extension PostListCollectionView: WaterFallLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        let pool: [CGFloat] = [300, 250, 320, 280]
        let randomIndex = Int.random(in: 0...2)
        let dynamicHeight = pool[randomIndex]
        return dynamicHeight
    }
}
