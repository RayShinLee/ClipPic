//
//  PublishViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/16.
//

import UIKit

class PublishViewController: UIViewController {
    
    // MARK: - Properties
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - UI Properties
    
    var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "Icons_24px_Back02"), for: .normal)
        backButton.imageView?.tintColor = .white
        return backButton
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitle("Upload an image", for: .normal)
        return addImageButton
    }()
    
    var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Enter title"
        return titleTextField
    }()
    
    var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Enter Description"
        return descriptionTextField
    }()
    
    var destinationLinkTextField: UITextField = {
        let destinationLinkTextField = UITextField()
        destinationLinkTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationLinkTextField.placeholder = "Enter link"
        return destinationLinkTextField
    }()
    
    var publishButton: UIButton = {
        let publishButton = UIButton()
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.setTitle("Post", for: .normal)
        return publishButton
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
    }
    
    // MARK: - methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func uploadImage() {
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func setUpViews() {
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                            constant: 16).isActive = true
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 20
        
        view.addSubview(addImageButton)
        addImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.backgroundColor = .systemGray
        
        view.addSubview(titleTextField)
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleTextField.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 50).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.backgroundColor = .systemGray
        
        view.addSubview(descriptionTextField)
        descriptionTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        descriptionTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 50).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextField.backgroundColor = .systemGray
        
        view.addSubview(destinationLinkTextField)
        destinationLinkTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        destinationLinkTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        destinationLinkTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor,
                                                      constant: 50).isActive = true
        destinationLinkTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        destinationLinkTextField.backgroundColor = .systemGray
        
        view.addSubview(publishButton)
        publishButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        publishButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        publishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        publishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        publishButton.backgroundColor = .systemGray
    }
}

extension PublishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
