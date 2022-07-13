//
//  AddCommentView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import UIKit
import Kingfisher

class AddCommentView: UIView {

    // MARK: - UI Properties
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        if let avatarURL = AccountManager.shared.appUser?.avatar {
            userImageView.kf.setImage(with: URL(string: avatarURL))
        }
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 25
        userImageView.clipsToBounds = true
        return userImageView
    }()
    
    var postCommentButton: UIButton = {
        let postCommentButton = UIButton()
        postCommentButton.translatesAutoresizingMaskIntoConstraints = false
        postCommentButton.setTitle("Post", for: .normal)
        postCommentButton.setTitleColor(.label, for: .normal)
        return postCommentButton
    }()

    var commentTextView: UITextView = {
        let commentTextView = UITextView()
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.backgroundColor = .clear
        commentTextView.font = UIFont(name: "PingFang TC", size: 18)
        //commentTextView.layer.cornerRadius = 20
        return commentTextView
    }()

    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        addSubview(userImageView)
        userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        userImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(postCommentButton)
        postCommentButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        postCommentButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        postCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5).isActive = true
        view.trailingAnchor.constraint(equalTo: postCommentButton.leadingAnchor, constant: 5).isActive = true
        view.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(commentTextView)
        commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        commentTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        commentTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}
