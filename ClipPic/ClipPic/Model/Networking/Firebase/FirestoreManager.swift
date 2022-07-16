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

// MARK: - User
extension FireStoreManager {
    
    func createUser(avatar: URL, username: String, firstName: String, lastName: String, completion: @escaping ((Error?) -> Void)) {
        guard let userUID = AccountManager.shared.userUID,
              let email = AccountManager.shared.currentFirebaseUser?.email else {
            fatalError("Invaid userUID")
        }
        let emptyArray: [String] = []
        let newDocument = Firestore.firestore().collection("User").document(userUID)
        let data: [String: Any] = [
           "user_name": username,
           "last_name": firstName,
           "first_name": lastName,
           "email": email,
           "created_time": Date().timeIntervalSince1970,
           "avatar": "\(avatar)",
           "collections": emptyArray,
           "followed_accounts": emptyArray,
           "blocked_accounts": emptyArray
        ]
        
        newDocument.setData(data) { error in
            if let error = error {
                completion(error)
            }
            let user = User(documentId: userUID, dictionary: data)
            AccountManager.shared.appUser = user
            completion(nil)
        }
    }
    
    func blockUser(blockedUser: SimpleUser, completion: @escaping ((Error?) -> Void)) {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        
        let userRef = dataBase.collection("User").document(user.id)
        userRef.getDocument { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                      completion(NetworkError.invalidSnapshot)
                      return
                  }
            let user = User(documentId: user.id, dictionary: data)
            let addedBlockedUser = blockedUser.rawValue
            var newBlockedAccounts = user.rawBlockedAccounts
            newBlockedAccounts.append(addedBlockedUser)
            
            userRef.updateData(["blocked_accounts": newBlockedAccounts]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                AccountManager.shared.appUser?.rawBlockedAccounts = newBlockedAccounts
                completion(nil)
            }
        }
    }

    func fetchProfile(completion: @escaping((User?, Error?) -> Void)) {
        guard let userUID = AccountManager.shared.userUID else {
            fatalError("Invaid userUID")
        }
        dataBase.collection("User").document(userUID).getDocument { snapShot, error in
            guard let snapShot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            guard let data = snapShot.data() else {
                completion(nil, NetworkError.emptyData)
                return
            }
            
            let user = User(documentId: userUID, dictionary: data)
            completion(user, nil)
        }
    }
    
    func fetchProfile(userUID: String, completion: @escaping((User?, Error?) -> Void)) {
        dataBase.collection("User").document(userUID).getDocument { snapShot, error in
            guard let snapShot = snapShot,
                  let data = snapShot.data() else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            let user = User(documentId: userUID, dictionary: data)
            completion(user, nil)
        }
    }
    
    func updateProfile(avatar: URL, firstname: String, lastname: String, completion: @escaping ((Error?) -> Void)) {
        guard let userId = AccountManager.shared.userUID else { return }
        
        let userRef = dataBase.collection("User").document(userId)
        
        let newData: [String: String] = [
            "first_name": firstname,
            "last_name": lastname,
            "avatar": "\(avatar)"
        ]
        
        userRef.updateData(newData) { error in
            guard error == nil else {
                completion(error)
                return
            }
            AccountManager.shared.appUser?.firstName = firstname
            AccountManager.shared.appUser?.lastName = lastname
            AccountManager.shared.appUser?.avatar = "\(avatar)"
            completion(nil)
        }
    }
    
    func fetchMyFollowersCount(completion: @escaping(Int) -> Void) {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        let simpleUser = SimpleUser(id: user.id, name: user.userName, avatar: user.avatar).rawValue
        let field = "followed_accounts"

        dataBase.collection("User").document().parent.whereField(field, arrayContains: simpleUser).getDocuments { snapShot, _ in
            guard let snapShot = snapShot else {
                completion(0)
                return
            }
            completion(snapShot.documents.count)
        }
    }
    
    func fetchCreatorFollowersCount(user: SimpleUser, completion: @escaping(Int) -> Void) {
        let field = "followed_accounts"

        dataBase.collection("User").document().parent.whereField(field, arrayContains: user.rawValue).getDocuments { snapShot, _ in
            guard let snapShot = snapShot else {
                completion(0)
                return
            }
            completion(snapShot.documents.count)
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
    
    func fetchPosts(with category: Category, completion: @escaping (([Post]?, Error?) -> Void)) {
        let reference = (category == Category.all) ?
        dataBase.collection("Post") :
        dataBase.collection("Post")
            .whereField("category", isEqualTo: category.rawValue)
        
        reference.getDocuments { snapShot, error in
            guard let snapshot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            var posts: [Post] = []
            snapshot.documents.forEach() { element in
                let post = Post(documentId: element.documentID, dictionary: element.data())
                posts.append(post)
            }
            
            // filter block list
            posts = posts.filter({ post in
                guard let blockList = AccountManager.shared.appUser?.blockedAccounts else {
                    return true
                }
                return !blockList.contains { user in
                    user.id == post.author.id
                }
            })
            
            completion(posts, nil)
        }
    }
    
    func fetchPosts(with author: SimpleUser, completion: @escaping (([Post]?, Error?) -> Void)) {
        let reference = dataBase.collection("Post").whereField("author", isEqualTo: author.rawValue)
        
        reference.getDocuments { snapShot, error in
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
        guard let user = AccountManager.shared.appUser else { return }
        let newDocument = Firestore.firestore().collection("Post").document()
        let data: [String: Any] = [
           "author": ["id": user.id,
                      "name": user.userName,
                      "avatar": user.avatar
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
        guard let user = AccountManager.shared.appUser else { return }
        let newDocument = Firestore.firestore().collection("Comment").document()
        let timeStamp = Date().timeIntervalSince1970

        let data: [String: Any] = [
            "creator": ["id": user.id,
                        "name": user.userName,
                        "avatar": user.avatar
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
        let ref = dataBase.collection("Comment").whereField("post_id", isEqualTo: postId)
        
        ref.getDocuments { snapShot, error in
            guard let snapshot = snapShot else {
                completion(nil, NetworkError.invalidSnapshot)
                return
            }
            
            var comments: [Comment] = []
            snapshot.documents.forEach() { element in
                let comment = Comment(documentId: element.documentID, dictionary: element.data())
                comments.append(comment)
            }
            
            // filter block list
            comments = comments.filter() { comment in
                guard let blockList = AccountManager.shared.appUser?.blockedAccounts else {
                    return true
                }
                return !blockList.contains { user in
                    return comment.creator.id == user.id
                }
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
    func savePost(collection: User.Collection, completion: @escaping ((Error?) -> Void)) {
        guard let userId = AccountManager.shared.userUID else { return }
        
        let userRef = dataBase.collection("User").document(userId)
        
        userRef.getDocument() { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                completion(NetworkError.invalidSnapshot)
                return
            }
            
            let user = User(documentId: userId, dictionary: data)
            let addedCollection = [
                "id": collection.id,
                "image_url": collection.imageURL
            ]
            var newCollections = user.rawCollections
            newCollections.append(addedCollection)
            
            userRef.updateData(["collections": newCollections]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                AccountManager.shared.appUser?.rawCollections = newCollections
                completion(nil)
            }
        }
    }
    
    func unsavePost(collection: User.Collection, completion: @escaping ((Error?) -> Void)) {
        guard let userId = AccountManager.shared.userUID else { return }
        
        let userRef = dataBase.collection("User").document(userId)
        
        userRef.getDocument() { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                completion(NetworkError.invalidSnapshot)
                return
            }
            
            let user = User(documentId: userId, dictionary: data)
            let toDeleteCollection = [
                "id": collection.id,
                "image_url": collection.imageURL
            ]
            var newCollections = user.rawCollections
            if let index = newCollections.firstIndex(where: { $0 == toDeleteCollection }) {
                newCollections.remove(at: index)
            }
            
            userRef.updateData(["collections": newCollections]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                AccountManager.shared.appUser?.rawCollections = newCollections
                completion(nil)
            }
        }
    }
}

extension FireStoreManager {
    func followAccount(followedAccount: SimpleUser, completion: @escaping ((Error?) -> Void)) {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        let userRef = dataBase.collection("User").document(user.id)
        userRef.getDocument { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                completion(NetworkError.invalidSnapshot)
                return
            }
            let user = User(documentId: user.id, dictionary: data)
            let addedFollowed = followedAccount.rawValue
            var newFollowedAccounts = user.rawFollowedAccounts
            newFollowedAccounts.append(addedFollowed)
            
            userRef.updateData(["followed_accounts": newFollowedAccounts]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                AccountManager.shared.appUser?.rawFollowedAccounts = newFollowedAccounts
                completion(nil)
            }
        }
    }
    
    func unFollowAccount(account: SimpleUser, completion: @escaping ((Error?) -> Void)) {
        guard let user = AccountManager.shared.appUser else {
            return
        }
        let userRef = dataBase.collection("User").document(user.id)
        userRef.getDocument { snapShot, error in
            guard let snapshot = snapShot,
                  let data = snapshot.data() else {
                completion(NetworkError.invalidSnapshot)
                return
            }
            let user = User(documentId: user.id, dictionary: data)
            let toDeleteFollowed = account.rawValue
            var newFollowedAccounts = user.rawFollowedAccounts
            
            if let index = newFollowedAccounts.firstIndex(where: { $0 == toDeleteFollowed }) {
                newFollowedAccounts.remove(at: index)
            }
            
            userRef.updateData(["followed_accounts": newFollowedAccounts]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                AccountManager.shared.appUser?.rawFollowedAccounts = newFollowedAccounts
                completion(nil)
            }
        }
    }
}
