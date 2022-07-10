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
    var firstName: String
    var lastName: String
    let userName: String
    let email: String
    var avatar: String
    var rawFollowedAccounts: [[String: String]]
    var rawBlockedAccounts: [[String: String]]
    var rawCollections: [[String: String]]
    
    var followedAccounts: [SimpleUser] {
        return rawFollowedAccounts.compactMap {
            guard let id = $0["id"] else { return nil }
            return SimpleUser(documentId: id, dictionary: $0)
        }
    }
    
    var blockedAccounts: [SimpleUser] {
        return rawBlockedAccounts.compactMap {
            guard let id = $0["id"] else { return nil }
            return SimpleUser(documentId: id, dictionary: $0)
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
              let rawBlockedAccounts = dictionary["blocked_accounts"] as? [[String: String]],
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
        self.rawBlockedAccounts = rawBlockedAccounts
        self.avatar = avatar
    }
    
    func isMySavedPost(_ postId: String) -> Bool {
        return collections.contains { $0.id == postId }
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
