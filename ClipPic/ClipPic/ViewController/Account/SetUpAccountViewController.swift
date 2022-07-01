//
//  SetUpAccountViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/28.
//

import UIKit
import SwiftUI

class SetUpAccountViewController: UIViewController {
    
    // MARK: - UI Properties
    
    var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .label
        backgroundView.layer.cornerRadius = 10
        return backgroundView
    }()
    
    var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemBackground
        return separatorView
    }()
    
    var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.lineBreakMode = .byWordWrapping
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "Welcome to ClipPic!\n Enter a unique user name and join the community."
        welcomeLabel.font = UIFont(name: "PingFang TC", size: 25.0)
        welcomeLabel.textColor = .systemBackground
        return welcomeLabel
    }()
    
    var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = "Enter user name"
        return userNameTextField
    }()
    
    var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .systemBackground
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = UIColor.label.cgColor
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    lazy var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.backgroundColor = .systemFill
        addImageButton.setTitleColor(.label, for: .normal)
        addImageButton.setTitle("Select image", for: .normal)
        addImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return addImageButton
    }()
    
    var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = .systemBackground
        nextButton.setTitleColor(.label, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        return nextButton
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action methods
    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func tapNextButton() {
        self.show(HomeViewController(), sender: nil)
    }
    
    // MARK: - Methods

    func setUpView() {
        
        view.addSubview(backgroundView)
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        backgroundView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -50).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        
        profileImage.addSubview(addImageButton)
        addImageButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        addImageButton.heightAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 0.2).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        addImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        
        setUpBackgroundView()
    }

    func setUpBackgroundView() {
        
        backgroundView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8).isActive = true

        backgroundView.addSubview(userNameTextField)
        userNameTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 25).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.9).isActive = true
        userNameTextField.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.1).isActive = true
        
        backgroundView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        backgroundView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        nextButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.1).isActive = true
    }
}

// MARK: - UIImagePickerController Delegate
extension SetUpAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

func imagePickerController(_ picker: UIImagePickerController,
                           didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.image = pickedImage
    }
    picker.dismiss(animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}
}
