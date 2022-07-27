//
//  SearchResultCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit
import Kingfisher

protocol SearchResultCollectionViewDelegate: AnyObject {
    func openWebView(with url: URL)
}

class SearchResultCollectionView: UICollectionView {
    
    // MARK: - Properties
    weak var interactionDelegate: SearchResultCollectionViewDelegate?
    
    var imageItems: [ImageItem] = [] {
        didSet {
            reloadData()
        }
    }

    // MARK: - View life cycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "searchResultCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - CollectionView DataSource & Delegate

extension SearchResultCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: CGFloat(fullScreenSize.width)/2 - 15.0, height: 250)
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath)
        guard let contentCell = cell as? SearchResultCollectionViewCell else {
            return cell
        }
        let item = imageItems[indexPath.item]
        
        contentCell.searchResultImageView.kf.setImage(with: URL(string: item.image.thumbnailLink))
        contentCell.searchResultTitleLabel.text = item.title
        return contentCell
    }
    
    // MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: imageItems[indexPath.item].link) else {
            return
        }
        interactionDelegate?.openWebView(with: url)
    }
}
