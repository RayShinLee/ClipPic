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
                                                       commentSectionStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution  = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    var commentSectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 30
        stackView.backgroundColor = .systemFill
        stackView.distribution  = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
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
        let saveButton = UIButton(type: .custom)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let imageSize = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .large)
        let image = UIImage(systemName: "paperclip.circle",
                            withConfiguration: imageSize)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        saveButton.setImage(image, for: .normal)
        return saveButton
    }()
    
    var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Icons_48x_share3")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        shareButton.setImage(image, for: .normal)
        return shareButton
    }()
    
    var contentImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    
    var postDescriptionView: UIView = {
       let postDescriptionView = UIView()
        postDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionView.layer.cornerRadius = 30
        postDescriptionView.backgroundColor = .systemFill
        return postDescriptionView
    }()
    
    let addCommentView = AddCommentView()
    
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
        setUpButtonActions()
        fetchPost()
    }
    
    // MARK: - Action Methods
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapSaveButton() {
        let collection = User.Collection(id: postId, imageURL: post.imageUrl)
        FireStoreManager.shared.savePost(userId: "b79Ms0w1mEEKdHb6VbmE", collection: collection) { error in
            if let error = error {
                print(error)
            } else {
                self.showAlert(title: "Saved!", message: "", optionTitle: "Ok")
            }
        }
    }
    
    @objc func tapSeeMoreButton() {
        self.present(CommentViewController(with: comments), animated: true, completion: nil)
    }
    
    @objc func tapShareButton() {
        let sharedText = "There is a funny post from ClipPic!\n\n\(post.title)\nby \(post.author.name)\n\(post.imageUrl)"
        var activityItems:[Any] = []
        if let image = contentImageView.image {
            activityItems = [sharedText, image]
        } else {
            activityItems = [sharedText]
        }
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func postCommentAction() {
        guard let comment = addCommentView.commentTextView.text,
              !comment.isEmpty else {
                  showAlert(title: "Error", message: "Empty Input", optionTitle: "Ok")
                  return
              }
        
        FireStoreManager.shared.publishComment(text: comment, post: postId, completion: {error in
            if let error = error {
                print(error)
            } else {
                self.fetchComments()
                self.showAlert(title: "Success", message: "", optionTitle: "Ok")
                self.addCommentView.commentTextView.text = ""
            }
        })
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
            self.fetchComments()
        }
    }
    
    func fetchComments() {
        guard let postId = post?.id else {
            return
        }
        
        FireStoreManager.shared.fetchComments(postId: postId, completion: { (comments, error) in
            if let error = error {
                print("Fail to fetch comments with error: \(error)")
            } else {
                self.comments = comments ?? []
                self.updateCommentSection()
            }
        })
    }
    
    func updateCommentSection() {
        
        commentSectionStackView.arrangedSubviews.forEach { view in
            commentSectionStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        if !comments.isEmpty {
            for index in 0 ..< comments.count {
                guard index < 2 else {
                    break
                }
                let commentView = CommentView()
                commentView.creatorNameLabel.text = comments[index].creator.name
                commentView.creatorThreadLabel.text = comments[index].text
                commentSectionStackView.addArrangedSubview(commentView)
            }
        }
        
        addCommentView.postCommentButton.addTarget(self, action: #selector(postCommentAction), for: .touchUpInside)
        commentSectionStackView.addArrangedSubview(addCommentView)
        
        if comments.count > 2 {
            let seeMoreCommentView = SeeMoreCommentView()
            seeMoreCommentView.seeMoreCommentsButton.addTarget(self, action: #selector(tapSeeMoreButton), for: .touchUpInside)
            commentSectionStackView.addArrangedSubview(seeMoreCommentView)
        }
    }
    
    func setUpButtonActions() {
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
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
        contentImageView.isUserInteractionEnabled = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: -8).isActive = true
        
        //  image description
        postDescriptionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        postDescriptionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.2).isActive = true
        
        setUpPostDescriptionView()
    }
    
    func setUpPostDescriptionView() {
        postDescriptionView.addSubview(shareButton)
        shareButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: postDescriptionView.trailingAnchor, constant: -16).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: postDescriptionView.bottomAnchor, constant: -16).isActive = true
    }
}
