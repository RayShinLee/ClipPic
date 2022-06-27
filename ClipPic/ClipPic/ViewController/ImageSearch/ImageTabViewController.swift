//
//  ImageTabViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/27.
//

import UIKit

class ImageTabViewController: UIViewController {
    
    // MARK: - UI Properties

    var imageSearchView: UIView = {
        let imageSearchView = UIView()
        imageSearchView.translatesAutoresizingMaskIntoConstraints = false
        imageSearchView.backgroundColor = .clear
        imageSearchView.layer.borderWidth = 2
        //imageSearchView.layer.borderColor =
        imageSearchView.layer.cornerRadius = 20
        return imageSearchView
    }()
    
    var imageSearchImageView: UIImageView = {
        let image = UIImage(systemName: "photo")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let imageSearchImageView = UIImageView(image: image)
        imageSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        return imageSearchImageView
    }()
    
    var imageSearchLabel: UILabel = {
        let imageSearchLabel = UILabel()
        imageSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSearchLabel.textAlignment = .center
        return imageSearchLabel
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    func setUpView() {
        
    }
    
}
