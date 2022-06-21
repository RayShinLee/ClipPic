//
//  Comment.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Comment {
    let id: String
    let creator: Creator
    let text: String
    let createdTime: String
    let postId: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let creator = dictionary["creator"] as? [String: Any],
              let creatorId = creator["id"] as? String,
              let text = dictionary["text"] as? String,
              let postId = dictionary["post_id"] as? String,
              let createdTime = dictionary["created_time"] as? String else {
                  fatalError("Init fail: Comment")
              }
 
        self.id = documentId
        self.text = text
        self.postId = postId
        self.creator = Creator(documentId: creatorId, dictionary: creator)
        self.createdTime = createdTime
    }
}

struct Creator {
    let id: String
    let name: String
    //let avatar: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let creatorName = dictionary["name"] as? String else {
              //    let avatar = dictionary["avatar"] as? String
            fatalError("Init fail: Creator")
        }
        
        self.id = documentId
        self.name = creatorName
        //  self.avatar = avatar
    }
}
