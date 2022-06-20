//
//  SearchViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/18.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search"
        searchTextField.leftViewMode = .always
        searchTextField.backgroundColor = .systemFill
        searchTextField.layer.cornerRadius = 20
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "Icons_24x_search")
        leftImage.image = image
        searchTextField.leftView = leftImage
        return searchTextField
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }

}
