//
//  TranslateTextViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/3.
//

import UIKit
import Vision

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
    
    var translateResultLabel: UILabel = {
        let translateResultLabel = UILabel()
        translateResultLabel.translatesAutoresizingMaskIntoConstraints = false
        translateResultLabel.lineBreakMode = .byWordWrapping
        translateResultLabel.numberOfLines = 0
        translateResultLabel.layer.borderWidth = 3
        return translateResultLabel
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
        
        view.addSubview(translateResultLabel)
        translateResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        translateResultLabel.topAnchor.constraint(equalTo: toSearchImageView.bottomAnchor, constant: 40).isActive = true
        translateResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        translateResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
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
            self.translateResultLabel.text = " 她確實表演了兩部電視特別節目\n在11月宣傳她的最新專輯30，但是這是她第一次正式的票務演出。"
        }
        
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en", "fr-FR", "it-IT", "de-DE", "es-ES"]
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        do {
            try handler.perform([request])
        } catch {
            print(error)
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