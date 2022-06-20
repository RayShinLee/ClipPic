//
//  Category.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Category {
    let id: String
    let name: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else {
            fatalError("Init fail: Category")
        }
        
        self.id = documentId
        self.name = name
    }
}
