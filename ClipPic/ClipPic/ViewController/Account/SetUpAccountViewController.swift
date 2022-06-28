//
//  SetUpAccountViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/28.
//

import UIKit

class SetUpAccountViewController: UIViewController {
    
    // MARK: - UI Properties
    
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
