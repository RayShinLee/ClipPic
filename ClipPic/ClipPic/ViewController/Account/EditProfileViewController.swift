//
//  AccountSettingViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/1.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var tableView: EditProfileTableView = {
        let tableView = EditProfileTableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .label
        profileImage.layer.cornerRadius = 10
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    lazy var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.backgroundColor = .systemFill
        addImageButton.setTitleColor(.systemBackground, for: .normal)
        addImageButton.setTitle("Select image", for: .normal)
        addImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return addImageButton
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 15
        doneButton.backgroundColor = .label
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        doneButton.setTitleColor(.systemBackground, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        return doneButton
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit profile"
        setUpView()
    }
   
    // MARK: - Action Methods
    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true)
        }
    }
    
    @objc func tapDoneButton() {
        guard let avatar = profileImageView.image,
              let imageData = avatar.jpegData(compressionQuality: 0.9),
              let newFirstName = tableView.firstName,
              let newLastName = tableView.lastName,
              !newFirstName.isEmpty,
              !newLastName.isEmpty else {
            print("remind user enter data")
            return
        }
        ClipPicProgressHUD.show()
        FirebaseStorageManager.shared.uploadImage(for: .avatar, with: imageData) { url in
            guard let avatarURL = url else {
                ClipPicProgressHUD.hide()
                return
            }
            FireStoreManager.shared.updateProfile(avatar: avatarURL, firstname: newFirstName, lastname: newLastName) { error in
                if let error = error {
                    print(error)
                } else {
                    KingfisherManager.shared.cache.removeImage(forKey: "\(avatarURL)") {
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
                ClipPicProgressHUD.hide()
            }
        }
        
    }
    
    // MARK: - Methods
    
    func setUpView() {
        view.backgroundColor = .systemBackground

        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        profileImageView.addSubview(addImageButton)
        addImageButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        addImageButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 0.2).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        addImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
}

    // MARK: - UIImagePickerController Delegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
