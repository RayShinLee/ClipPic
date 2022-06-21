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
        // comment set to cell labels, fix constraints
        return commentCell
    }
}
