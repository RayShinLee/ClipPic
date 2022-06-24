//
//  SearchViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/18.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    
    var googleImages: [ImageItem] = []
    
    // MARK: - UI Properties
    
    var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search"
        searchTextField.leftViewMode = .always
        searchTextField.backgroundColor = .systemFill
        searchTextField.layer.cornerRadius = 20
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: "magnifyingglass")
        image?.withTintColor(.white)
        leftImage.image = image
        searchTextField.leftView = leftImage
        return searchTextField
    }()
    
    var searchResultCollectionView: SearchResultCollectionView = {
        let searchResultCollectionView = SearchResultCollectionView()
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return searchResultCollectionView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        searchKeyword()
    }
    
    func searchKeyword() {
        GoogleSearchAPIManager().getSeachImages(keyword: "Appworks") { image, error in
            if let error = error {
                print(error)
                return
            }
            self.googleImages = image ?? []
            print(self.googleImages)
        }
    }
    
    func setUpViews() {
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true
        searchResultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchResultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchResultCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
    }

}
