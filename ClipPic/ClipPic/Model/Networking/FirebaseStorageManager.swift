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
    
    func uploadPostImage(with data: Data, completion: @escaping ((URL?) -> Void)) {
        let storageRef = storage.reference()
        let timeStamp = "\(Date().timeIntervalSince1970)"
        let imagesRef = storageRef.child("posts/\(timeStamp).jpeg")

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
