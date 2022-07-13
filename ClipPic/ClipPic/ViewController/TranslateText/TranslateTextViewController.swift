//
//  TranslateTextViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/3.
//

import UIKit
import Vision

class TranslateTextViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        return scrollView
    }()
    
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
    
    var translateResultLabel: UILabel = {
        let translateResultLabel = UILabel()
        translateResultLabel.translatesAutoresizingMaskIntoConstraints = false
        translateResultLabel.lineBreakMode = .byWordWrapping
        translateResultLabel.numberOfLines = 0
        translateResultLabel.layer.borderWidth = 3
        translateResultLabel.font = UIFont.systemFont(ofSize: 20.0)
        return translateResultLabel
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Methods
    
    func translateImage() {
        guard let cgImage = toSearchImageView.image?.cgImage else {
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                      return
                  }
            
            let text = observations.compactMap( {
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            self.translateResultLabel.text = text
        }
        
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en", "fr-FR", "it-IT", "de-DE", "es-ES"]
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
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
        
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: toSearchImageView.bottomAnchor, constant: 20).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(translateResultLabel)
        translateResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        translateResultLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        translateResultLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        translateResultLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension TranslateTextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            toSearchImageView.contentMode = .scaleToFill
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
