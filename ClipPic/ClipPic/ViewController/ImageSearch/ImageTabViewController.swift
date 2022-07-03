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
    
    var translateImageButton: UIButton = {
        let translateImageButton = UIButton()
        translateImageButton.translatesAutoresizingMaskIntoConstraints = false
        translateImageButton.backgroundColor = .label
        translateImageButton.layer.cornerRadius = 20
        return translateImageButton
    }()
    
    var imageSearchImageView: UIImageView = {
        let imageSearchImageView = UIImageView()
        imageSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        imageSearchImageView.image = UIImage(named: "photoIcon")
        return imageSearchImageView
    }()
    
    var translateImageView: UIImageView = {
        let translateImageView = UIImageView()
        translateImageView.translatesAutoresizingMaskIntoConstraints = false
        translateImageView.image = UIImage(named: "translateIcon")
        return translateImageView
    }()
    
    var imageSearchTitleLabel: UILabel = {
        let imageSearchTitleLabel = UILabel()
        imageSearchTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSearchTitleLabel.textAlignment = .left
        imageSearchTitleLabel.font = UIFont(name: "PingFang TC", size: 20.0)
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
    
    var translateTitleLabel: UILabel = {
        let translateTitleLabel = UILabel()
        translateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        translateTitleLabel.lineBreakMode = .byWordWrapping
        translateTitleLabel.numberOfLines = 0
        translateTitleLabel.textAlignment = .left
        translateTitleLabel.font = UIFont(name: "PingFang TC", size: 19.0)
        translateTitleLabel.textColor = .systemBackground
        translateTitleLabel.text = "Translate Image Text!"
        return translateTitleLabel
    }()
    
    var translateDescriptionLabel: UILabel = {
        let translateDescriptionLabel = UILabel()
        translateDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        translateDescriptionLabel.textAlignment = .left
        translateDescriptionLabel.font = UIFont(name: "PingFang TC", size: 16.0)
        translateDescriptionLabel.lineBreakMode = .byWordWrapping
        translateDescriptionLabel.numberOfLines = 0
        translateDescriptionLabel.textColor = .systemBackground
        translateDescriptionLabel.text = "Upload a photo with foreign text and receive immediate translation."
        return translateDescriptionLabel
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
        
        view.addSubview(translateImageButton)
        translateImageButton.topAnchor.constraint(equalTo: imageSearchButton.bottomAnchor, constant: 20).isActive = true
        translateImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        translateImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        translateImageButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        setUpImageSearchButton()
        setUpTranslateButton()
    }
    
    func setUpImageSearchButton() {
        imageSearchButton.addSubview(imageSearchImageView)
        imageSearchImageView.centerYAnchor.constraint(equalTo: imageSearchButton.centerYAnchor).isActive = true
        imageSearchImageView.leadingAnchor.constraint(equalTo: imageSearchButton.leadingAnchor).isActive = true
        imageSearchImageView.widthAnchor.constraint(equalTo: imageSearchButton.widthAnchor, multiplier: 0.45).isActive = true
        imageSearchImageView.heightAnchor.constraint(equalTo: imageSearchButton.heightAnchor, multiplier: 0.5).isActive = true
        
        imageSearchButton.addSubview(imageSearchTitleLabel)
        imageSearchTitleLabel.topAnchor.constraint(equalTo: imageSearchImageView.topAnchor).isActive = true
        imageSearchTitleLabel.leadingAnchor.constraint(equalTo: imageSearchImageView.trailingAnchor).isActive = true
        imageSearchTitleLabel.trailingAnchor.constraint(equalTo: imageSearchButton.trailingAnchor, constant: 5).isActive = true
        imageSearchTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        imageSearchButton.addSubview(imageSearchDescriptionLabel)
        imageSearchDescriptionLabel.centerYAnchor.constraint(equalTo: imageSearchImageView.centerYAnchor).isActive = true
        imageSearchDescriptionLabel.leadingAnchor.constraint(equalTo: imageSearchTitleLabel.leadingAnchor).isActive = true
        imageSearchDescriptionLabel.trailingAnchor.constraint(equalTo: imageSearchTitleLabel.trailingAnchor).isActive = true
    }
    
    func setUpTranslateButton() {
        translateImageButton.addSubview(translateImageView)
        translateImageView.centerYAnchor.constraint(equalTo: translateImageButton.centerYAnchor).isActive = true
        translateImageView.leadingAnchor.constraint(equalTo: translateImageButton.leadingAnchor, constant: 5).isActive = true
        translateImageView.widthAnchor.constraint(equalTo: translateImageButton.widthAnchor, multiplier: 0.40).isActive = true
        translateImageView.heightAnchor.constraint(equalTo: translateImageView.widthAnchor).isActive = true
        
        translateImageButton.addSubview(translateTitleLabel)
        translateTitleLabel.topAnchor.constraint(equalTo: translateImageView.topAnchor).isActive = true
        translateTitleLabel.leadingAnchor.constraint(equalTo: translateImageView.trailingAnchor, constant: 2).isActive = true
        translateTitleLabel.trailingAnchor.constraint(equalTo: translateImageButton.trailingAnchor, constant: 5).isActive = true
        translateTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        translateImageButton.addSubview(translateDescriptionLabel)
        translateDescriptionLabel.centerYAnchor.constraint(equalTo: translateImageView.centerYAnchor).isActive = true
        translateDescriptionLabel.trailingAnchor.constraint(equalTo: translateTitleLabel.trailingAnchor).isActive = true
        translateDescriptionLabel.leadingAnchor.constraint(equalTo: translateTitleLabel.leadingAnchor).isActive = true
    }
}
