//
//  SeeMoreCommentView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/22.
//

import UIKit

class SeeMoreCommentView: UIView {
    
    var seeMoreCommentsButton: UIButton = {
       let seeMoreCommentsButton = UIButton()
        seeMoreCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreCommentsButton.setTitle("See More", for: .normal)
        seeMoreCommentsButton.setTitleColor(.systemBackground, for: .normal)
        seeMoreCommentsButton.backgroundColor = .label
        seeMoreCommentsButton.layer.cornerRadius = 10
        return seeMoreCommentsButton
    }()

    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        addSubview(seeMoreCommentsButton)
        seeMoreCommentsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        seeMoreCommentsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        seeMoreCommentsButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        seeMoreCommentsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        seeMoreCommentsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }

}
