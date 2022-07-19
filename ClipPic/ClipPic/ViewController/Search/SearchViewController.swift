//
//  SearchViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/18.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    var searchIconImageView: UIImageView = {
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search"
        searchTextField.backgroundColor = .clear
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        return searchTextField
    }()
    
    lazy var searchResultCollectionView: SearchResultCollectionView = {
        let searchResultCollectionView = SearchResultCollectionView()
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchResultCollectionView.interactionDelegate = self
        return searchResultCollectionView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
    }
    
    func searchKeyword(keyword: String) {
        guard !keyword.isEmpty else {
            return
        }
        GoogleSearchAPIManager().getSeachImages(keyword: keyword) { images, error in
            if let error = error {
                print(error)
                return
            }
            guard let imageItems = images else { return }
            self.searchResultCollectionView.imageItems = imageItems
        }
    }
    
    func setUpViews() {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        stackView.addArrangedSubview(searchIconImageView)
        searchIconImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        searchIconImageView.heightAnchor.constraint(equalTo: searchIconImageView.widthAnchor).isActive = true
        
        let textFieldContainer = UIView(frame: .zero)
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.backgroundColor = .systemFill
        textFieldContainer.layer.cornerRadius = 24
        textFieldContainer.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 8).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -8).isActive = true
        
        stackView.addArrangedSubview(textFieldContainer)
        textFieldContainer.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        searchResultCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchResultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchResultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

    // MARK: - UITextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if let text = textField.text, !text.isEmpty {
            searchKeyword(keyword: text)
        }
        return true
    }
}

    // MARK: - SearchResultCollectionView Delegate
extension SearchViewController: SearchResultCollectionViewDelegate {
    func openWebView(with url: URL) {
        let safariViewContorller = SFSafariViewController(url: url)
        present(safariViewContorller, animated: true, completion: nil)
    }
}
