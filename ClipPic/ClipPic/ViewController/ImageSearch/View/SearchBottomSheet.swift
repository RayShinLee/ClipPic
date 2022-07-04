//
//  searchBottomSheet.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/18.
//

import UIKit

class SearchBottomSheet: UIView {
    // MARK: - UI Properties
    
    var imageSearchButton: UIButton = {
        let imageSearchButton = UIButton()
        imageSearchButton.translatesAutoresizingMaskIntoConstraints = false
        imageSearchButton.setTitle("Image Search", for: .normal)
        imageSearchButton.setTitleColor(.systemBackground, for: .normal)
        imageSearchButton.backgroundColor = .label
        return imageSearchButton
    }()
    
    var translateImageButton: UIButton = {
        let translateImageButton = UIButton()
        translateImageButton.translatesAutoresizingMaskIntoConstraints = false
        translateImageButton.setTitle("Translate Image Text", for: .normal)
        translateImageButton.setTitleColor(.systemBackground, for: .normal)
        translateImageButton.backgroundColor = .label
        return translateImageButton
    }()
    
    var exitButton: UIButton = {
        let exitButton = UIButton.init(type: .custom)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        return exitButton
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action Methods
    
    // MARK: - Methods
    
    func setUpView() {
        layer.cornerRadius = 15
        backgroundColor = .white
        
        self.addSubview(imageSearchButton)
        imageSearchButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        imageSearchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        imageSearchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        imageSearchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(translateImageButton)
        translateImageButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        translateImageButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        translateImageButton.topAnchor.constraint(equalTo: imageSearchButton.bottomAnchor, constant: 20).isActive = true
        translateImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(exitButton)
        exitButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
    }
}
