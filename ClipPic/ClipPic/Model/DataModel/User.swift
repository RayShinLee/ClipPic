//
//  User.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation

struct User {
    let id: String
    let createdTime: Double
    let firstName: String
    let lastName: String
    let userName: String
    let email: String
    //  let avatar: String
    let followAccounts: FollowAccounts
    let collections: Collections
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let createdTime = dictionary["created_time"] as? Double,
              let firstName = dictionary["first_name"] as? String,
              let lastName = dictionary["last_name"] as? String,
              let userName = dictionary["user_name"] as? String,
              let email = dictionary["email"] as? String,
              //    let avatar = dictionary["avatar"] as? String,
              let followAccounts = dictionary["follow_accounts"] as? [String: Any],
              let followAccountsId = followAccounts["id"] as? String,
              let collections = dictionary["collections"] as? [String: Any],
              let collectionsId = collections["id"] as? String else {
                  fatalError("Init fail: User")
              }
 
        self.id = documentId
        self.createdTime = createdTime
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.email = email
        //  self.avatar = avatar
        self.followAccounts = FollowAccounts(documentId: followAccountsId, dictionary: followAccounts)
        self.collections = Collections(documentId: collectionsId, dictionary: collections)
    }
    
}

struct FollowAccounts {
    let id: String
    let name: String
    //  let avatar: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else {
              //    let avatar = dictionary["avatar"] as? String
            fatalError("Init fail: Followed Accounts")
        }
        
        self.id = documentId
        self.name = name
        //  self.avatar = avatar
    }
}

struct Collections {
    let id: String
    let imageURL: String
    
    init(documentId: String, dictionary: [String: Any]) {
        guard let imageURL = dictionary["image_url"] as? String else {
            fatalError("Init fail: Collections")
        }
        
        self.id = documentId
        self.imageURL = imageURL
    }
}
