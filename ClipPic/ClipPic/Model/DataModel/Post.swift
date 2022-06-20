//
//  Post.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Post {
    let id: String
    let author: [Author]
    let category: [Category]
    let description: String
    let imageUrl: String
    let referenceLink: String?
    let title: String
}

struct Author {
    let id: String
    let name: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let authorName = dictionary["name"] as? String else {
            fatalError("Init fail: Author")
        }
        
        self.id = documentId
        self.name = authorName
    }
}
