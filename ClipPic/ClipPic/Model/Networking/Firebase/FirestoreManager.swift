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
    
    func fetchPost(postId: String, completion: @escaping ((Post?, Error?) -> Void)) {
        dataBase.collection("Post").document(postId).getDocument { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            let post = Post(documentId: postId, dictionary: data)
            completion(post, nil)
        }
    }
    
    func fetchPosts(completion: @escaping (([Post]?, Error?) -> Void)) {
        dataBase.collection("Post").getDocuments { snapShot, error in
            guard let snapshot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            var posts: [Post] = []
            snapshot.documents.forEach() { element in
                let post = Post(documentId: element.documentID, dictionary: element.data())
                posts.append(post)
            }
            
            completion(posts, nil)
        }
        
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

// MARK: - Comments

extension FireStoreManager {
    func publishComment(text: String, post: String, completion: @escaping ((Error?) -> Void)) {
        let newDocument = Firestore.firestore().collection("Comment").document()
        let timeStamp = Date().timeIntervalSince1970

        let data: [String: Any] = [
            "creator": [
                "id": "b79Ms0w1mEEKdHb6VbmE",
                "name": "rayshinlee"
                //  "avatar": "",
            ],
            "text": text,
            "created_time": timeStamp,
            "post_id": post
        ]
        newDocument.setData(data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchComments(postId: String, completion: @escaping (([Comment]?, Error?) -> Void)) {
        dataBase.collection("Comment").whereField("post_id", isEqualTo: postId).getDocuments { snapShot, error in
            guard let snapshot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            var comments: [Comment] = []
            snapshot.documents.forEach() { element in
                let comment = Comment(documentId: element.documentID, dictionary: element.data())
                comments.append(comment)
            }
            
            comments.sort { data0, data1 in
                return data0.createdTime > data1.createdTime
            }
            
            completion(comments, nil)
        }
        
    }
}

// MARK: - Save Post

extension FireStoreManager {
    func savePost() {
        
    }
}

