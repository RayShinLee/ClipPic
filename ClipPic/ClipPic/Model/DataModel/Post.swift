//
//  Post.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Post {
    let id: String
    let author: Author
    let category: Category
    let description: String
    let imageUrl: String
    let referenceLink: String?
    let title: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let description = dictionary["description"] as? String,
              let imageUrl = dictionary["image_url"] as? String,
              let title = dictionary["title"] as? String,
              let author = dictionary["author"] as? [String: Any],
              let authorId = author["id"] as? String,
              let category = dictionary["category"] as? [String: Any],
              let categoryId = category["id"] as? String else {
                  fatalError("Init fail: Post")
              }
 
        self.description = description
        self.id = documentId
        self.imageUrl = imageUrl
        self.category = Category(documentId: categoryId, dictionary: category)
        self.referenceLink = dictionary["reference_link"] as? String
        self.title = title
        self.author = Author(documentId: authorId, dictionary: author)
    }
}

struct Author {
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
