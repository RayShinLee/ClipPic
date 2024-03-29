//
//  CommentView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import UIKit

class CommentView: UIView {
    
    // MARK: - UI Properties
    
    var creatorImageView: UIImageView = {
        let creatorImageView = UIImageView()
        creatorImageView.translatesAutoresizingMaskIntoConstraints = false
        creatorImageView.image = UIImage(named: "lemon")
        creatorImageView.contentMode = .scaleAspectFill
        creatorImageView.layer.cornerRadius = 25
        creatorImageView.clipsToBounds = true
        return creatorImageView
    }()

    var creatorThreadLabel: UILabel = {
        let creatorThreadLabel = UILabel()
        creatorThreadLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorThreadLabel.numberOfLines = 2
        creatorThreadLabel.textColor = .label
        creatorThreadLabel.backgroundColor = .clear
        return creatorThreadLabel
    }()
    
    var creatorNameLabel: UILabel = {
        let creatorNameLabel = UILabel()
        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.textColor = .label
        return creatorNameLabel
    }()
    
    var commentDateLabel: UILabel = {
       let commentDateLabel = UILabel()
       commentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        commentDateLabel.textColor = .lightGray
       commentDateLabel.font = UIFont.systemFont(ofSize: 16.0)
       return commentDateLabel
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
        //  comment profile pic
        addSubview(creatorImageView)
        creatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        creatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        creatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        creatorImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        creatorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //  comment name
        addSubview(creatorNameLabel)
        creatorNameLabel.topAnchor.constraint(equalTo: creatorImageView.topAnchor).isActive = true
        creatorNameLabel.leadingAnchor.constraint(equalTo: creatorImageView.trailingAnchor, constant: 5).isActive = true
        creatorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        //  comment content
        addSubview(creatorThreadLabel)
        creatorThreadLabel.topAnchor.constraint(equalTo: creatorNameLabel.bottomAnchor).isActive = true
        creatorThreadLabel.leadingAnchor.constraint(equalTo: creatorNameLabel.leadingAnchor).isActive = true
        creatorThreadLabel.trailingAnchor.constraint(equalTo: creatorNameLabel.trailingAnchor).isActive = true
        creatorThreadLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // comment date
        addSubview(commentDateLabel)
        commentDateLabel.topAnchor.constraint(equalTo: creatorNameLabel.topAnchor).isActive = true
        commentDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        commentDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
