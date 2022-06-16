//
//  ImageViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "Icons_24px_Back02"), for: .normal)
        backButton.imageView?.tintColor = .white
        return backButton
    }()
    
    var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(named: "bookmark-56-512"), for: .normal)
        saveButton.setImage(UIImage(named: "bookmark-43-512"), for: .selected)
        return saveButton
    }()
    
    var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)

    }
    
    // MARK: - Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        view.addSubview(image)
        image.heightAnchor.constraint(equalToConstant: 500).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        image.image = UIImage(named: "Icons_24px_Visa")
        
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        
        image.addSubview(saveButton)
        image.bringSubviewToFront(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -8).isActive = true
    }

}
