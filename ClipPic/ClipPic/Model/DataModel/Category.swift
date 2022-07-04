//
//  Category.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct Category: Equatable {
    let id: String
    let name: String
    
    var rawValue: [String: String] {
        return ["id": id, "name": name]
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else {
            fatalError("Init fail: Category")
        }
        
        self.id = documentId
        self.name = name
    }
}

extension Category {
    static let all = Category(id: "", name: "All")
}
