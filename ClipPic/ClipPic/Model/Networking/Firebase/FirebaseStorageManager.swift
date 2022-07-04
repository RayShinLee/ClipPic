//
//  FirebaseStorageManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    let storage: Storage
    
    private init() {
        storage = Storage.storage()
    }
    
    func uploadImage(for task: UploadTask, with data: Data, completion: @escaping ((URL?) -> Void)) {
        guard let userUID = AccountManager.shared.userUID else {
            completion(nil)
            return
        }
        
        let storageRef = storage.reference()
        var imagesRef: StorageReference
        switch task {
        case .post:
            let timeStamp = "\(Date().timeIntervalSince1970)"
            imagesRef = storageRef.child("/\(userUID)/\(timeStamp).jpeg")
        case .avatar:
            imagesRef = storageRef.child("/\(userUID)/avatar.jpeg")
        }
        imagesRef.putData(data, metadata: nil) { (metadata, error) in
            imagesRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }
}

extension FirebaseStorageManager {
    enum UploadTask: String {
        case post = "Posts"
        case avatar = "Avatars"
    }
}
