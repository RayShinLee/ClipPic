//
//  SimpleUser.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/10.
//

import Foundation

struct SimpleUser {
    let id: String
    let name: String
    let avatar: String
    
    var rawValue: [String: String] {
        return ["id": id, "name": name, "avatar": avatar]
    }
    
    init(id: String, name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let authorName = dictionary["name"] as? String,
              let avatar = dictionary["avatar"] as? String else {
            fatalError("Init fail: Author")
        }
        
        self.id = documentId
        self.name = authorName
        self.avatar = avatar
    }
}
