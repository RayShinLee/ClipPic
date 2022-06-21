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
    
    var exitButton: UIButton = {
        let exitButton = UIButton.init(type: .custom)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.layer.cornerRadius = 20
        exitButton.imageView?.tintColor = .label
        return exitButton
    }()
    
    var tableView: CommentTableView = {
        let tableView = CommentTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle
    
    init(with comments: [Comment]) {
        self.tableView.comments = comments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        setUpView()
        buttonActions()
    }
    
    // MARK: - Action methods
    
    @objc func tapBackButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Methods
    
    func buttonActions() {
        exitButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    func setUpView() {
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(exitButton)
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
    }
}
