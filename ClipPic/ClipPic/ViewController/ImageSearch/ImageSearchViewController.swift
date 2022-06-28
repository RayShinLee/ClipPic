//
//  ImageSearchViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import UIKit
import Kingfisher

class ImageSearchViewController: UIViewController {
    
    var serpImages: [SerpImage] = []
    
    var toSearchImageView: UIImageView = {
        let toSearchImageView = UIImageView()
        toSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        toSearchImageView.isUserInteractionEnabled = true
        toSearchImageView.backgroundColor = .systemFill
        return toSearchImageView
    }()
    
    var addImageButton: UIButton = {
        let addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitle("Select and Search", for: .normal)
        addImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        addImageButton.backgroundColor = .systemFill
        return addImageButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "contentCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        setUpView()
    }

    func setUpView() {
        view.addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(toSearchImageView)
        toSearchImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        toSearchImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toSearchImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toSearchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        toSearchImageView.layer.cornerRadius = 20
        
        view.addSubview(addImageButton)
        addImageButton.bottomAnchor.constraint(equalTo: toSearchImageView.bottomAnchor, constant: -8).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func uploadAndSearchImage() {
        guard let imageData = toSearchImageView.image?.jpegData(compressionQuality: 1.0) else {return}

        // 1. Upload image to firebase storage
        FirebaseStorageManager.shared.uploadSearchImage(with: imageData) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                // upload fail
                return
            }
            // 2. Search image with SerpAPI
            SerpAPIManager().search(with: "\(downloadURL)") { serpImages, error in
                if let error = error {
                    print(error)
                    return
                }
                self.serpImages = serpImages ?? []
                self.collectionView.reloadData()
            }
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: FlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullScreenSize = UIScreen.main.bounds.size
        return CGSize(width: CGFloat(fullScreenSize.width)/2 - 15.0, height: CGFloat(fullScreenSize.width)/2 - 15.0)
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serpImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
        guard let contentCell = cell as? PostCollectionViewCell else {
            return cell
        }
        let serpImage = serpImages[indexPath.item]
        contentCell.homeImageView.kf.setImage(with: URL(string: serpImage.thumbnail))
        contentCell.homeImageView.contentMode = .scaleAspectFit
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
}

// MARK: - UIImagePickerController Delegate
extension ImageSearchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            toSearchImageView.contentMode = .scaleAspectFill
            toSearchImageView.clipsToBounds = true
            toSearchImageView.image = pickedImage
            
            uploadAndSearchImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
