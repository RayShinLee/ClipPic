//
//  ImageViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {
    
    // MARK: - Properties
    
    var comments: [Comment] = []
    
    var postId: String
    
    var post: Post! {
        didSet {
            contentImageView.kf.setImage(with: URL(string: post.imageUrl))
        }
    }
    
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
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.imageView?.tintColor = .systemBackground
        backButton.backgroundColor = .label
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
        postCommentButton.setTitleColor(.label, for: .normal)
        return postCommentButton
    }()
    
    var seeMoreCommentsButton: UIButton = {
       let seeMoreCommentsButton = UIButton()
        seeMoreCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreCommentsButton.setTitle("See More", for: .normal)
        seeMoreCommentsButton.setTitleColor(.systemBackground, for: .normal)
        seeMoreCommentsButton.backgroundColor = .label
        seeMoreCommentsButton.layer.cornerRadius = 10
        return seeMoreCommentsButton
    }()
    
    var contentImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
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
    
    var commentTextView: UITextView = {
        let commentTextView = UITextView()
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.backgroundColor = .clear
        //NSAttributedString(string: "Add a comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return commentTextView
    }()
    
    var commentCreatorThreadLabel: UITextView = {
        let commentCreatorThreadLabel = UITextView()
        commentCreatorThreadLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel.text = "Creator comment appears here. Creator comment appears here. Creator comment appears here. Creator comment appears here. Creator comment appears here. Creator comment appears here"
        commentCreatorThreadLabel.font?.pointSize
        commentCreatorThreadLabel.textColor = .label
        commentCreatorThreadLabel.backgroundColor = .clear
        return commentCreatorThreadLabel
    }()
    
    var commentCreatorThreadLabel2: UILabel = {
        let commentCreatorThreadLabel2 = UILabel()
        commentCreatorThreadLabel2.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel2.text = "Creator comment appears here. Creator comment appears here"
        commentCreatorThreadLabel2.textColor = .label
        return commentCreatorThreadLabel2
    }()
    
    var commentCreatorName1: UILabel = {
        let commentCreatorName1 = UILabel()
        commentCreatorName1.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorName1.text = "Creator 1"
        commentCreatorName1.textColor = .label
        return commentCreatorName1
    }()
    
    var commentCreatorName2: UILabel = {
        let commentCreatorName2 = UILabel()
        commentCreatorName2.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorName2.text = "Creator 2"
        commentCreatorName2.textColor = .label
        return commentCreatorName2
    }()
    
    // MARK: - Lifecycle
    
    init(with postId: String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        postCommentButton.addTarget(self, action: #selector(postCommentAction), for: .touchUpInside)
        fetchPost()
    }
    
    // MARK: - Action Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postCommentAction() {
        guard let comment = commentTextView.text,
              !comment.isEmpty else {
                  showAlert(title: "Error", message: "Empty Input", optionTitle: "Ok")
                  return
              }
        showAlert(title: "Success", message: "", optionTitle: "Ok")
        commentTextView.text = ""
        
        //FireStoreManager.shared.publishComment(text: comment, post: )
    }

    // MARK: - Methods
    
    func fetchPost() {
        FireStoreManager.shared.fetchPost(postId: postId) { post, error in
            if let error = error {
                print("Fail to fetch post with error: \(error)")
            }
            guard let post = post else {
                return
            }
            self.post = post
        }
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
        
        //  comment name
        commentSectionView.addSubview(commentCreatorName1)
        commentCreatorName1.topAnchor.constraint(equalTo: commentCreatorImageView.topAnchor).isActive = true
        commentCreatorName1.leadingAnchor.constraint(equalTo: commentCreatorImageView.trailingAnchor, constant: 5).isActive = true
        
        commentSectionView.addSubview(commentCreatorName2)
        commentCreatorName2.topAnchor.constraint(equalTo: commentCreatorImageView2.topAnchor).isActive = true
        commentCreatorName2.leadingAnchor.constraint(equalTo: commentCreatorImageView2.trailingAnchor, constant: 5).isActive = true
        
        //  comment content
        commentSectionView.addSubview(commentCreatorThreadLabel)
        commentCreatorThreadLabel.topAnchor.constraint(equalTo: commentCreatorName1.bottomAnchor).isActive = true
        commentCreatorThreadLabel.leadingAnchor.constraint(equalTo: commentCreatorName1.leadingAnchor).isActive = true
        commentCreatorThreadLabel.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
        commentCreatorThreadLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentSectionView.addSubview(commentCreatorThreadLabel2)
        commentCreatorThreadLabel2.topAnchor.constraint(equalTo: commentCreatorName2.bottomAnchor, constant: 1).isActive = true
        commentCreatorThreadLabel2.leadingAnchor.constraint(equalTo: commentCreatorName2.leadingAnchor).isActive = true
        commentCreatorThreadLabel2.trailingAnchor.constraint(equalTo: commentCreatorThreadLabel.trailingAnchor).isActive = true
        commentCreatorThreadLabel2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentSectionView.addSubview(commentTextView)
        commentTextView.centerYAnchor.constraint(equalTo: commentUserPicImageView.centerYAnchor).isActive = true
        commentTextView.leadingAnchor.constraint(equalTo: commentUserPicImageView.trailingAnchor, constant: 5).isActive = true
        commentTextView.heightAnchor.constraint(equalTo: commentUserPicImageView.heightAnchor).isActive = true
        
        //  comment buttons
        commentSectionView.addSubview(postCommentButton)
        postCommentButton.centerYAnchor.constraint(equalTo: commentUserPicImageView.centerYAnchor).isActive = true
        postCommentButton.leadingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: 5).isActive = true
        postCommentButton.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
        
        commentSectionView.addSubview(seeMoreCommentsButton)
        seeMoreCommentsButton.centerXAnchor.constraint(equalTo: commentSectionView.centerXAnchor).isActive = true
        seeMoreCommentsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        seeMoreCommentsButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        seeMoreCommentsButton.bottomAnchor.constraint(equalTo: commentSectionView.bottomAnchor, constant: -10).isActive = true
    }
}
