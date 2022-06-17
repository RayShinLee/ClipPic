//
//  ImageViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit
import FirebaseFirestore

class ImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataBase: Firestore!
    var allPosts: [[String: Any]] = []
    
    // MARK: - UI Properties
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentImageView,
                                                       postDescriptionView,
                                                       commentSectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //  stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "Icons_24px_Back02"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.imageView?.tintColor = .white
        backButton.backgroundColor = .white
        return backButton
    }()
    
    var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(named: "bookmark-56-512"), for: .normal)
        saveButton.setImage(UIImage(named: "bookmark-43-512"), for: .selected)
        return saveButton
    }()
    
    var contentImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Icons_24px_Visa")
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 20
        return image
    }()
    
    var postDescriptionView: UIView = {
       let postDescriptionView = UIView()
        postDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionView.layer.cornerRadius = 30
        postDescriptionView.backgroundColor = .systemFill
        return postDescriptionView
    }()
    
    var commentSectionView: UIView = {
        let commentSectionView = UIView()
        commentSectionView.translatesAutoresizingMaskIntoConstraints = false
        commentSectionView.layer.cornerRadius = 30
        commentSectionView.backgroundColor = .systemFill
        return commentSectionView
    }()
    
    var commentUserPicView: UIImageView = {
        let commentUserPicView = UIImageView()
        commentUserPicView.translatesAutoresizingMaskIntoConstraints = false
        commentUserPicView.image = UIImage(named: "Icons_24px_Visa")
        commentUserPicView.contentMode = .scaleToFill
        commentUserPicView.layer.cornerRadius = 25
        return commentUserPicView
    }()
    
    var commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "Add a comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return commentTextField
    }()
    
    var postCommentButton: UIButton = {
        let postCommentButton = UIButton()
        postCommentButton.translatesAutoresizingMaskIntoConstraints = false
        postCommentButton.setTitle("Post", for: .normal)
        postCommentButton.setTitleColor(.systemBlue, for: .normal)
        return postCommentButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        postCommentButton.addTarget(self, action: #selector(postCommentAction), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postCommentAction() {
        guard let comment = commentTextField.text,
              !comment.isEmpty else {
                  showAlert(title: "Error", message: "Empty Input", optionTitle: "Ok")
                  return
              }
        addNewComment(commentContent: comment)
        showAlert(title: "Publish Success!", message: "", optionTitle: "Ok")
        commentTextField.text = ""
    }
    
    // MARK: - Methods
    
    func addNewComment(commentContent: String) {
        let posts = Firestore.firestore().collection("Comment")
        let document = posts.document()
        let timeStamp = Date().timeIntervalSince1970

        let data: [String: Any] = [
            "userId": "1234",
            "postId": "",
            "commentContent": commentContent,
            "createdTime": timeStamp
        ]
    
        document.setData(data)
    }
    
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
        
        scrollView.addSubview(backButton)
        scrollView.bringSubviewToFront(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        //   image
        contentImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5).isActive = true
        contentImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        //  save button
        contentImageView.addSubview(saveButton)
        contentImageView.bringSubviewToFront(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: -8).isActive = true
        
        //  image descripton
        postDescriptionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        postDescriptionView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2).isActive = true
        
        //  comment section
        commentSectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        commentSectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        commentSectionView.addSubview(commentUserPicView)
        commentUserPicView.leadingAnchor.constraint(equalTo: commentSectionView.leadingAnchor, constant: 10).isActive = true
        commentUserPicView.bottomAnchor.constraint(equalTo: commentSectionView.bottomAnchor, constant: -40).isActive = true
        commentUserPicView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentUserPicView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentSectionView.addSubview(commentTextField)
        commentTextField.centerYAnchor.constraint(equalTo: commentUserPicView.centerYAnchor).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: commentUserPicView.trailingAnchor, constant: 5).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentUserPicView.heightAnchor).isActive = true
        
        commentSectionView.addSubview(postCommentButton)
        postCommentButton.centerYAnchor.constraint(equalTo: commentUserPicView.centerYAnchor).isActive = true
        postCommentButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 5).isActive = true
        postCommentButton.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
    }
}
