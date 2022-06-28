//
//  ImageTabViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/27.
//

import UIKit

class ImageTabViewController: UIViewController {
    
    // MARK: - UI Properties

    var imageSearchButton: UIButton = {
        let imageSearchButton = UIButton()
        imageSearchButton.translatesAutoresizingMaskIntoConstraints = false
        imageSearchButton.backgroundColor = .label
        imageSearchButton.layer.cornerRadius = 20
        return imageSearchButton
    }()
    
    var imageSearchImageView: UIImageView = {
        let image = UIImage(systemName: "photo")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        let imageSearchImageView = UIImageView(image: image)
        imageSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        return imageSearchImageView
    }()
    
    var imageSearchTitleLabel: UILabel = {
        let imageSearchTitleLabel = UILabel()
        imageSearchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSearchTitleLabel.textAlignment = .center
        imageSearchTitleLabel.font = UIFont(name: "PingFang TC", size: 20.0)
        imageSearchTitleLabel.lineBreakMode = .byWordWrapping
        imageSearchTitleLabel.numberOfLines = 0
        imageSearchTitleLabel.textColor = .systemBackground
        imageSearchTitleLabel.text = "Search by Images!"
        return imageSearchTitleLabel
    }()
    
    var imageSearchDescriptionLabel: UILabel = {
        let imageSearchLabel = UILabel()
        imageSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSearchLabel.textAlignment = .left
        imageSearchLabel.font = UIFont(name: "PingFang TC", size: 16.0)
        imageSearchLabel.lineBreakMode = .byWordWrapping
        imageSearchLabel.numberOfLines = 0
        imageSearchLabel.textColor = .systemBackground
        imageSearchLabel.text = "Upload a photo and discover visually similar images."
        return imageSearchLabel
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        imageSearchButton.addTarget(self, action: #selector(tapimageSearchButton), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    
    @objc func tapimageSearchButton() {
        self.show(ImageSearchViewController(), sender: nil)
    }
    
    // MARK: - Methods
    
    func setUpView() {
        view.addSubview(imageSearchButton)
        imageSearchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        imageSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageSearchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        imageSearchButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        setUpViewContents()
    }
    
    func setUpViewContents() {
        imageSearchButton.addSubview(imageSearchImageView)
        imageSearchImageView.centerYAnchor.constraint(equalTo: imageSearchButton.centerYAnchor).isActive = true
        imageSearchImageView.leadingAnchor.constraint(equalTo: imageSearchButton.leadingAnchor).isActive = true
        imageSearchImageView.widthAnchor.constraint(equalTo: imageSearchButton.widthAnchor, multiplier: 0.5).isActive = true
        imageSearchImageView.heightAnchor.constraint(equalTo: imageSearchImageView.widthAnchor).isActive = true
        
        imageSearchButton.addSubview(imageSearchTitleLabel)
        imageSearchTitleLabel.topAnchor.constraint(equalTo: imageSearchButton.topAnchor, constant: 50).isActive = true
        imageSearchTitleLabel.trailingAnchor.constraint(equalTo: imageSearchButton.trailingAnchor, constant: -5).isActive = true
        imageSearchTitleLabel.widthAnchor.constraint(equalTo: imageSearchButton.widthAnchor, multiplier: 0.5).isActive = true
        imageSearchTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        imageSearchButton.addSubview(imageSearchDescriptionLabel)
        imageSearchDescriptionLabel.topAnchor.constraint(equalTo: imageSearchTitleLabel.bottomAnchor).isActive = true
        imageSearchDescriptionLabel.trailingAnchor.constraint(equalTo: imageSearchTitleLabel.trailingAnchor).isActive = true
        imageSearchDescriptionLabel.widthAnchor.constraint(equalTo: imageSearchButton.widthAnchor, multiplier: 0.5).isActive = true
    }
    
}
