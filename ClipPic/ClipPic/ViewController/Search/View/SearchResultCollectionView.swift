//
//  SearchResultCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit

class SearchResultCollectionView: UICollectionView {

    // MARK: - Properties
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath)
        guard let contentCell = cell as? SearchResultCollectionViewCell else {
            return cell
        }
        
        contentCell.searchResultImageView.image = UIImage(named: "Gardener")
        contentCell.searchResultTitleLabel.text = "search results. search results. search results."
        return contentCell
    }
    
    // MARK: Delegate

}
