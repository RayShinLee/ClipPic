//
//  SetUpAccountViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/28.
//

import UIKit

class SetUpAccountViewController: UIViewController {
    
    // MARK: - UI Properties
    
    var userNameBackgroundView: UIView = {
        let userNameBackgroundView = UIView()
        userNameBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        userNameBackgroundView.backgroundColor = .label
        userNameBackgroundView.layer.cornerRadius = 10
        return userNameBackgroundView
    }()
    
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "User Name"
        userNameLabel.font = UIFont(name: "PingFang TC", size: 25.0)
        userNameLabel.textColor = .systemBackground
        return userNameLabel
    }()
    
    var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = "Enter userName"
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.layer.borderWidth = 2.0
        userNameTextField.layer.borderColor = CGColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return userNameTextField
    }()
    
    var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .systemFill
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.backgroundColor = .systemFill
        addImageButton.setTitleColor(.label, for: .normal)
        addImageButton.setTitle("Select image", for: .normal)
        addImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return addImageButton
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
    
    // MARK: - Methods

    func setUpView() {
        view.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        
        profileImage.addSubview(addImageButton)
        addImageButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        addImageButton.heightAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 0.2).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        addImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        
        view.addSubview(userNameBackgroundView)
        userNameBackgroundView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 50).isActive = true
        userNameBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        userNameBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        setUpUserNameBackgroundView()
    }

    func setUpUserNameBackgroundView() {
        userNameBackgroundView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: userNameBackgroundView.topAnchor, constant: 20).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userNameBackgroundView.leadingAnchor, constant: 15).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userNameBackgroundView.addSubview(userNameTextField)
        userNameTextField.bottomAnchor.constraint(equalTo: userNameBackgroundView.bottomAnchor, constant: -10).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: userNameBackgroundView.centerXAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: userNameBackgroundView.widthAnchor, multiplier: 0.9).isActive = true
        userNameTextField.heightAnchor.constraint(equalTo: userNameBackgroundView.heightAnchor, multiplier: 0.4).isActive = true
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
