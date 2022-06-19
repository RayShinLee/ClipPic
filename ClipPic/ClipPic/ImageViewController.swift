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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentImageView,
                                                       postDescriptionView,
                                                       commentSectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution  = .equalSpacing
        stackView.alignment = .fill
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
    
    var postCommentButton: UIButton = {
        let postCommentButton = UIButton()
        postCommentButton.translatesAutoresizingMaskIntoConstraints = false
        postCommentButton.setTitle("Post", for: .normal)
        postCommentButton.setTitleColor(.systemBlue, for: .normal)
        return postCommentButton
    }()
    
    var seeMoreCommentsButton: UIButton = {
       let seeMoreCommentsButton = UIButton()
        seeMoreCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreCommentsButton.setTitle("See More", for: .normal)
        seeMoreCommentsButton.setTitleColor(.white, for: .normal)
        seeMoreCommentsButton.backgroundColor = .black
        seeMoreCommentsButton.layer.cornerRadius = 10
        return seeMoreCommentsButton
    }()
    
    var contentImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "lemon")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    
    var commentUserPicImageView: UIImageView = {
        let commentUserPicView = UIImageView()
        commentUserPicView.translatesAutoresizingMaskIntoConstraints = false
        commentUserPicView.image = UIImage(named: "Quokdog")
        commentUserPicView.contentMode = .scaleAspectFill
        commentUserPicView.layer.cornerRadius = 25
        commentUserPicView.clipsToBounds = true
        return commentUserPicView
    }()
    
    var commentCreatorImageView: UIImageView = {
        let commentCreatorImageView = UIImageView()
        commentCreatorImageView.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorImageView.image = UIImage(named: "lemon")
        commentCreatorImageView.contentMode = .scaleAspectFill
        commentCreatorImageView.layer.cornerRadius = 25
        commentCreatorImageView.clipsToBounds = true
        return commentCreatorImageView
    }()
    
    var commentCreatorImageView2: UIImageView = {
        let commentCreatorImageView2 = UIImageView()
        commentCreatorImageView2.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorImageView2.image = UIImage(named: "Gardener")
        commentCreatorImageView2.contentMode = .scaleAspectFill
        commentCreatorImageView2.layer.cornerRadius = 25
        commentCreatorImageView2.clipsToBounds = true
        return commentCreatorImageView2
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
    
    var commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "Add a comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return commentTextField
    }()
    
    var commentCreatorThreadLabel: UILabel = {
        let commentCreatorThreadLabel = UILabel()
        commentCreatorThreadLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel.numberOfLines = 3
        commentCreatorThreadLabel.text = "Creator comment appears here. Creator comment appears here"
        commentCreatorThreadLabel.textColor = .label
        return commentCreatorThreadLabel
    }()
    
    var commentCreatorThreadLabel2: UILabel = {
        let commentCreatorThreadLabel2 = UILabel()
        commentCreatorThreadLabel2.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel2.numberOfLines = 3
        commentCreatorThreadLabel2.text = "Creator comment appears here. Creator comment appears here"
        commentCreatorThreadLabel2.textColor = .label
        return commentCreatorThreadLabel2
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
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
    
    func setUpView() {
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        //   image
        contentImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5).isActive = true
        contentImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        //  save button
        contentImageView.addSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: -8).isActive = true
        
        //  image description
        postDescriptionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        postDescriptionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.2).isActive = true
        
        setUpCommentSection()
    }
    
    func setUpContentImageView() {
        
    }
    
    func setUpCommentSection() {
        //  comment section
        commentSectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        commentSectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3).isActive = true
        
        //  comment profile pic
        commentSectionView.addSubview(commentCreatorImageView)
        commentCreatorImageView.topAnchor.constraint(equalTo: commentSectionView.topAnchor, constant: 20).isActive = true
        commentCreatorImageView.leadingAnchor.constraint(equalTo: commentSectionView.leadingAnchor, constant: 10).isActive = true
        commentCreatorImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentCreatorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentSectionView.addSubview(commentCreatorImageView2)
        commentCreatorImageView2.topAnchor.constraint(equalTo: commentCreatorImageView.bottomAnchor, constant: 10).isActive = true
        commentCreatorImageView2.leadingAnchor.constraint(equalTo: commentCreatorImageView.leadingAnchor).isActive = true
        commentCreatorImageView2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentCreatorImageView2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentSectionView.addSubview(commentUserPicImageView)
        commentUserPicImageView.leadingAnchor.constraint(equalTo: commentSectionView.leadingAnchor, constant: 10).isActive = true
        commentUserPicImageView.bottomAnchor.constraint(equalTo: commentSectionView.bottomAnchor, constant: -50).isActive = true
        commentUserPicImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentUserPicImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //  comment content
        commentSectionView.addSubview(commentCreatorThreadLabel)
        commentCreatorThreadLabel.leadingAnchor.constraint(equalTo: commentCreatorImageView.trailingAnchor, constant: 5).isActive = true
        commentCreatorThreadLabel.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
        commentCreatorThreadLabel.centerYAnchor.constraint(equalTo: commentCreatorImageView.centerYAnchor).isActive = true
        commentCreatorThreadLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentSectionView.addSubview(commentCreatorThreadLabel2)
        commentCreatorThreadLabel2.leadingAnchor.constraint(equalTo: commentCreatorThreadLabel.leadingAnchor).isActive = true
        commentCreatorThreadLabel2.trailingAnchor.constraint(equalTo: commentCreatorThreadLabel.trailingAnchor).isActive = true
        commentCreatorThreadLabel2.centerYAnchor.constraint(equalTo: commentCreatorImageView2.centerYAnchor).isActive = true
        commentCreatorThreadLabel2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentSectionView.addSubview(commentTextField)
        commentTextField.centerYAnchor.constraint(equalTo: commentUserPicImageView.centerYAnchor).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: commentUserPicImageView.trailingAnchor, constant: 5).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentUserPicImageView.heightAnchor).isActive = true
        
        //  comment buttons
        commentSectionView.addSubview(postCommentButton)
        postCommentButton.centerYAnchor.constraint(equalTo: commentUserPicImageView.centerYAnchor).isActive = true
        postCommentButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 5).isActive = true
        postCommentButton.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
        
        commentSectionView.addSubview(seeMoreCommentsButton)
        seeMoreCommentsButton.centerXAnchor.constraint(equalTo: commentSectionView.centerXAnchor).isActive = true
        seeMoreCommentsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        seeMoreCommentsButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        seeMoreCommentsButton.bottomAnchor.constraint(equalTo: commentSectionView.bottomAnchor, constant: -10).isActive = true
    }
}
