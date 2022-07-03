//
//  TranslateTextViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/3.
//

import UIKit
import Firebase

class TranslateTextViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        
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
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true)
        }
    }
    
    func translateImage() {
        guard let image = toSearchImageView.image else {
            return
        }
        
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { visionText, error in
            if let error = error {
                print(error)
            } else {
                print(visionText)
            }
        }
    }
}

extension TranslateTextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            toSearchImageView.contentMode = .scaleAspectFill
            toSearchImageView.clipsToBounds = true
            toSearchImageView.image = pickedImage
            
            translateImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
