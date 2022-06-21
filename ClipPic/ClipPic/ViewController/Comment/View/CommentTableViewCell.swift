//
//  CommentTableViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    var commentSectionView: UIView = {
        let commentSectionView = UIView()
        commentSectionView.translatesAutoresizingMaskIntoConstraints = false
        commentSectionView.layer.cornerRadius = 30
        commentSectionView.backgroundColor = .systemFill
        return commentSectionView
    }()
    
    var commentCreatorImageView: UIImageView = {
        let commentCreatorImageView = UIImageView()
        commentCreatorImageView.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorImageView.image = UIImage(named: "Quokdog")
        commentCreatorImageView.contentMode = .scaleAspectFill
        commentCreatorImageView.layer.cornerRadius = 25
        commentCreatorImageView.clipsToBounds = true
        return commentCreatorImageView
    }()
    
    var commentDateLabel: UILabel = {
       let commentDateLabel = UILabel()
       commentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        commentDateLabel.text = "2022/2/22"
       return commentDateLabel
    }()
    
    var commentCreatorName: UILabel = {
        let commentCreatorName = UILabel()
        commentCreatorName.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorName.text = "ooooooo"
        commentCreatorName.textColor = .label
        return commentCreatorName
    }()
    
    var commentCreatorThreadLabel: UILabel = {
        let commentCreatorThreadLabel = UILabel()
        commentCreatorThreadLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel.text = "xxxxxxx"
        commentCreatorThreadLabel.textColor = .label
        commentCreatorThreadLabel.backgroundColor = .clear
        return commentCreatorThreadLabel
    }()

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - Methods
    
    func setUpView() {
        //  comment section
        self.addSubview(commentSectionView)
        commentSectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        commentSectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        commentSectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentSectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        //  comment profile pic
        commentSectionView.addSubview(commentCreatorImageView)
        commentCreatorImageView.topAnchor.constraint(equalTo: commentSectionView.topAnchor, constant: 20).isActive = true
        commentCreatorImageView.leadingAnchor.constraint(equalTo: commentSectionView.leadingAnchor, constant: 10).isActive = true
        commentCreatorImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentCreatorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //  comment name
        commentSectionView.addSubview(commentCreatorName)
        commentCreatorName.topAnchor.constraint(equalTo: commentCreatorImageView.topAnchor).isActive = true
        commentCreatorName.leadingAnchor.constraint(equalTo: commentCreatorImageView.trailingAnchor, constant: 5).isActive = true
        
        //  comment content
        commentSectionView.addSubview(commentCreatorThreadLabel)
        commentCreatorThreadLabel.topAnchor.constraint(equalTo: commentCreatorName.bottomAnchor).isActive = true
        commentCreatorThreadLabel.leadingAnchor.constraint(equalTo: commentCreatorName.leadingAnchor).isActive = true
        commentCreatorThreadLabel.trailingAnchor.constraint(equalTo: commentSectionView.trailingAnchor, constant: -10).isActive = true
        commentCreatorThreadLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
