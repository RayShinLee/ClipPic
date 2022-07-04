//
//  User.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct User: Codable {
    let id: String
    let createdTime: Double
    let firstName: String
    let lastName: String
    let userName: String
    let email: String
    let avatar: String
    let rawFollowedAccounts: [[String: String]]
    var rawCollections: [[String: String]]
    
    var followedAccounts: [FollowedAccount] {
        return rawFollowedAccounts.compactMap {
            guard let id = $0["id"] else { return nil }
            return FollowedAccount(documentId: id, dictionary: $0)
        }
    }
    var collections: [Collection] {
        return rawCollections.compactMap {
            guard let id = $0["id"] else { return nil }
            return Collection(documentId: id, dictionary: $0)
        }
    }
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let firstName = dictionary["first_name"] as? String,
              let lastName = dictionary["last_name"] as? String,
              let userName = dictionary["user_name"] as? String,
              let email = dictionary["email"] as? String,
              let avatar = dictionary["avatar"] as? String,
              let createdTime = dictionary["created_time"] as? Double,
              let rawFollowAccounts = dictionary["followed_accounts"] as? [[String: String]],
              let rawCollections = dictionary["collections"] as? [[String: String]]
        else {
                  fatalError("Init fail: User")
              }
 
        self.id = documentId
        self.createdTime = createdTime
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.email = email
        self.rawCollections = rawCollections
        self.rawFollowedAccounts = rawFollowAccounts
        self.avatar = avatar
    }
    
    func isMySavedPost(_ postId: String) -> Bool {
        return collections.contains { $0.id == postId }
    }
 
    struct FollowedAccount: Codable {
        let id: String
        let name: String
        let avatar: String
        
        init(id: String, name: String, avatar: String) {
            self.id = id
            self.name = name
            self.avatar = avatar
        }
        
        init(documentId: String, dictionary: [String: Any]) {
            guard let name = dictionary["name"] as? String,
                  let avatar = dictionary["avatar"] as? String else {
                fatalError("Init fail: Followed Accounts")
            }
            
            self.id = documentId
            self.name = name
            self.avatar = avatar
        }
    }
    
    struct Collection: Codable {
        let id: String
        let imageURL: String
        
        init(id: String, imageURL: String) {
            self.id = id
            self.imageURL = imageURL
        }
        
        init(documentId: String, dictionary: [String: Any]) {
            guard let imageURL = dictionary["image_url"] as? String else {
                fatalError("Init fail: Collections")
            }
            
            self.id = documentId
            self.imageURL = imageURL
        }
    }
}
