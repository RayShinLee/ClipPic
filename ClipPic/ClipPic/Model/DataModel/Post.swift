//
//  Post.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Post {
    let id: String
    let author: SimpleUser
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
        self.author = SimpleUser(documentId: authorId, dictionary: author)
    }
}
