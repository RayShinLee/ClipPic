//
//  FirestoreManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation
import FirebaseFirestore

class FireStoreManager {
    
    static let shared = FireStoreManager()
    
    var dataBase: Firestore
    
    private init() {
        dataBase = Firestore.firestore()
    }
}

// MARK: - Category
extension FireStoreManager {
    func fetchCategories(completion: @escaping (([Category]?, Error?) -> Void)) {
        dataBase.collection("Category").getDocuments { snapShot, error in
            guard let snapshot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            var categories: [Category] = []
            snapshot.documents.forEach() { element in
                let category = Category(documentId: element.documentID, dictionary: element.data())
                categories.append(category)
            }
            
            completion(categories, nil)
        }
    }
}

// MARK: - Post
extension FireStoreManager {
    func fetchPosts() {
        
    }
    
    func publishPost(imageURL: String, title: String, category: Category, referenceLink: String?, description: String) {
        let newDocument = Firestore.firestore().collection("Post").document()
        let data: [String: Any] = [
           "author": [
               "id": "b79Ms0w1mEEKdHb6VbmE",
               "name": "rayshinlee"
           ],
           "title": title,
           "image_url": imageURL,
           "description": description,
           "reference_link": referenceLink,
           "category": ["id": category.id, "name": category.name]
        ]
        newDocument.setData(data) { error in
            if let error = error {
                print(error)
            }
            print("success")
        }
    }
}
