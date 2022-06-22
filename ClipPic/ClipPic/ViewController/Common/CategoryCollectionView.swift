//
//  CategoryCollectionView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/20.
//

import UIKit

protocol CategoryCollectionViewDelegate: AnyObject {
    func didSelectCategoryAt(_ categoryCollectionView: CategoryCollectionView, at index: Int)
}

class CategoryCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    weak var interactionDelegate: CategoryCollectionViewDelegate?
    
    var categories: [Category] = [] {
        didSet {
            if !categories.isEmpty {
                selectedCategory = categories[0]
            }
        }
    }
    
    var selectedCategory: Category?
    
    // MARK: - View life cycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        showsVerticalScrollIndicator = false
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: FlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullScreenSize = UIScreen.main.bounds.size
        return CGSize(width: CGFloat(fullScreenSize.width)/4, height: 30)
    }
    
    // MARK: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        guard let category = categoryCell as? CategoryCollectionViewCell else {
            return categoryCell
        }
        category.layer.cornerRadius = 15
        
        let categories = categories[indexPath.item]
        category.titleLabel.text = categories.name
        if selectedCategory?.id == categories.id {
            category.backgroundColor = .label
            category.titleLabel.textColor = .systemBackground
        } else {
            category.backgroundColor = .clear
            category.titleLabel.textColor = .label
        }
        return category
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategory = category
        collectionView.reloadData()
        
        //interactionDelegate?.didSelectCategoryAt(self, at: selectedCategory)
    }
}
