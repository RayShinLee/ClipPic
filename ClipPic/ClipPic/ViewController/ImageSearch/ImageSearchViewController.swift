//
//  ImageSearchViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import UIKit
import Kingfisher
import SafariServices

class ImageSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var serpImages: [SerpImage] = []
    
    // MARK: - UI Properties
    
    var toSearchImageView: UIImageView = {
        let toSearchImageView = UIImageView()
        toSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        toSearchImageView.isUserInteractionEnabled = true
        toSearchImageView.backgroundColor = .systemFill
        return toSearchImageView
    }()
    
    lazy var addImageButton: UIButton = {
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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        setUpView()
    }

    // MARK: - ACtion Methods
    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true)
        }
    }
    
    // MARK: - Methods
    
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
    
    func uploadAndSearchImage() {
        guard let imageData = toSearchImageView.image?.jpegData(compressionQuality: 0.1) else {return}
        
        ClipPicProgressHUD.show()
        
        // 1. Upload image to Imgur
        ImgurManager().uploadImage(imageData: imageData) { result, error in
            guard let url = result?.data.link else {
                ClipPicProgressHUD.hide()
                return
            }

            // 2. Search image with SerpAPI
            SerpAPIManager().search(with: "\(url)") { serpImages, error in
                if let error = error {
                    print(error)
                    ClipPicProgressHUD.hide()
                    return
                }
                self.serpImages = serpImages ?? []
                self.collectionView.reloadData()
                ClipPicProgressHUD.hide()
            }
        }
    }
}

    // MARK: - UICollectionView

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
        contentCell.homeImageView.contentMode = .scaleAspectFill
        contentCell.layer.cornerRadius = 20
        return contentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: serpImages[indexPath.item].link) else { return }
        let safariViewContorller = SFSafariViewController(url: url)
        present(safariViewContorller, animated: true, completion: nil)
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
