//
//  PublishViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/16.
//

import UIKit
import FirebaseFirestore

class PublishViewController: UIViewController {
    
    // MARK: - Properties
    var categories: [Category] = []
    var selectedCategory: Category? = nil
    
    var fullScreenSize: CGSize!
    // MARK: - UI Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        return scrollView
    }()
    
    var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "Icons_24px_Back02"), for: .normal)
        backButton.imageView?.tintColor = .white
        return backButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toPostImageView,
                                                       addImageButton,
                                                       titleTextField,
                                                       descriptionTextField,
                                                       destinationLinkTextField,
                                                       categoryCollectionView,
                                                       publishButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //  stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    var toPostImageView: UIImageView = {
        let imageToPost = UIImageView()
        imageToPost.translatesAutoresizingMaskIntoConstraints = false
        imageToPost.backgroundColor = .red
        return imageToPost
    }()
    
    var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitle("Select an image", for: .normal)
        addImageButton.backgroundColor = .black
        return addImageButton
    }()
    
    var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Enter title"
        titleTextField.layer.borderColor = CGColor.init(red: 0/255, green: 0/255, blue: 0.255, alpha: 1)
        return titleTextField
    }()
    
    var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Enter Description"
        descriptionTextField.layer.borderColor = CGColor.init(red: 0/255, green: 0/255, blue: 0.255, alpha: 1)
        return descriptionTextField
    }()
    
    var destinationLinkTextField: UITextField = {
        let destinationLinkTextField = UITextField()
        destinationLinkTextField.translatesAutoresizingMaskIntoConstraints = false
        destinationLinkTextField.placeholder = "Enter link"
        destinationLinkTextField.layer.borderColor = CGColor.init(red: 0/255, green: 0/255, blue: 0.255, alpha: 1)
        return destinationLinkTextField
    }()
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var publishButton: UIButton = {
        let publishButton = UIButton()
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.setTitle("Post", for: .normal)
        publishButton.backgroundColor = .black
        return publishButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        addImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        publishButton.addTarget(self, action: #selector(publish), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        
        fetchCategories()
    }
    
    func fetchCategories() {
        FireStoreManager.shared.fetchCategories() { (categories, error) in
            if let error = error {
                print("Fail to fetch categories with error: \(error)")
            } else {
                self.categories = categories ?? []
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Action methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func uploadImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func publish() {
        guard let title = titleTextField.text,
              let description = descriptionTextField.text,
              !title.isEmpty,
              !description.isEmpty,
              let imageData = toPostImageView.image?.jpegData(compressionQuality: 1.0),
              let category = selectedCategory else {
                  showAlert(title: "Error", message: "Empty Input", optionTitle: "Ok")
                  return
              }
        // 1. Upload image to firebase storage
        FirebaseStorageManager.shared.uploadPostImage(with: imageData) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                // upload fail
                return
            }
            // 2. Pubish post to fireStore database
            FireStoreManager.shared.publishPost(imageURL: "\(downloadURL)",
                                                title: title,
                                                category: category,
                                                referenceLink: self.destinationLinkTextField.text,
                                                description: description)
        }
    }
    
    // MARK: - methods
    func showAlert(title: String, message: String, optionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: optionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setUpViews() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        toPostImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        toPostImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
        toPostImageView.layer.cornerRadius = 20
        
        addImageButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        descriptionTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        destinationLinkTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        destinationLinkTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        categoryCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        publishButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        publishButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        stackView.addSubview(backButton)
        stackView.bringSubviewToFront(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                            constant: 16).isActive = true
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
    }
}

    // MARK: - CollectionView

extension PublishViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        fullScreenSize = UIScreen.main.bounds.size
        return CGSize(
            width: CGFloat(fullScreenSize.width)/3,
            height: 30)
    }
}

extension PublishViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        categoryCell.titleLabel.text = category.name
        if selectedCategory?.id == category.id {
            categoryCell.titleLabel.textColor = .systemRed
        } else {
            categoryCell.titleLabel.textColor = .label
        }
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategory = category
        collectionView.reloadData()
    }
}

    // MARK: - UIImagePickerController Delegate
extension PublishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            toPostImageView.contentMode = .scaleAspectFill
            toPostImageView.clipsToBounds = true
            toPostImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
