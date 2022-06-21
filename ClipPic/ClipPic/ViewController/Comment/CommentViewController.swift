//
//  CommentViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/20.
//

import UIKit

class CommentViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - UI Properties
    
    var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.imageView?.tintColor = .systemBackground
        backButton.backgroundColor = .label
        return backButton
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    func buttonActions() {
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    func setUpView() {
        view.addSubview(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
}
