//
//  CommentTableViewCell.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
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
       commentDateLabel.font = UIFont(name: "System", size: 10.0)
       return commentDateLabel
    }()
    
    var commentCreatorName: UILabel = {
        let commentCreatorName = UILabel()
        commentCreatorName.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorName.font = UIFont(name: "System", size: 20.0)
        commentCreatorName.textColor = .label
        return commentCreatorName
    }()
    
    var commentCreatorThreadLabel: UILabel = {
        let commentCreatorThreadLabel = UILabel()
        commentCreatorThreadLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCreatorThreadLabel.numberOfLines = 0
        commentCreatorThreadLabel.font = UIFont(name: "System", size: 20.0)
        commentCreatorThreadLabel.textColor = .label
        commentCreatorThreadLabel.backgroundColor = .clear
        return commentCreatorThreadLabel
    }()

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - Methods
    
    func setUpView() {
        
        //  comment profile pic
        contentView.addSubview(commentCreatorImageView)
        commentCreatorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        commentCreatorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        commentCreatorImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentCreatorImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //  comment name
        contentView.addSubview(commentCreatorName)
        commentCreatorName.topAnchor.constraint(equalTo: commentCreatorImageView.topAnchor).isActive = true
        commentCreatorName.leadingAnchor.constraint(equalTo: commentCreatorImageView.trailingAnchor, constant: 5).isActive = true
        
        //  comment content
        contentView.addSubview(commentCreatorThreadLabel)
        commentCreatorThreadLabel.topAnchor.constraint(equalTo: commentCreatorName.bottomAnchor).isActive = true
        commentCreatorThreadLabel.leadingAnchor.constraint(equalTo: commentCreatorName.leadingAnchor).isActive = true
        commentCreatorThreadLabel.widthAnchor.constraint(equalToConstant: 320).isActive = true
        //commentCreatorThreadLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // comment date
        contentView.addSubview(commentDateLabel)
        commentDateLabel.topAnchor.constraint(equalTo: commentCreatorThreadLabel.bottomAnchor, constant: 5).isActive = true
        commentDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2).isActive = true
        commentDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        commentDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
