//
//  CommentTableView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import UIKit

class CommentTableView: UITableView {

    // MARK: - Properties
    
    var comments: [Comment] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - View life cycle
    init() {
        super.init(frame: .zero, style: .plain)
        self.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommentTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let commentCell = cell as? CommentTableViewCell else {
            return cell
        }
        
        let createdTime = Date(timeIntervalSince1970: comments[indexPath.row].createdTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        commentCell.commentDateLabel.text = dateFormatter.string(from: createdTime)
        commentCell.commentCreatorName.text = comments[indexPath.row].creator.name
        commentCell.commentCreatorThreadLabel.text = comments[indexPath.row].text
        return commentCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
