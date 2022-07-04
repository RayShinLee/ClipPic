//
//  ImgurManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/2.
//

import Foundation
import Alamofire

class ImgurManager {
    
    func uploadImage(imageData: Data, completion: @escaping (UploadImageResult?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "Client-ID 56334deffc1cf14"]
        let uploadURL = "https://api.imgur.com/3/image"
        
        AF.upload(multipartFormData: { data in
            data.append(imageData, withName: "image")
        }, to: uploadURL, headers: headers).responseDecodable(of: UploadImageResult.self,
                                                              queue: .main,
                                                              decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let result):
                completion(result, nil)
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }
}

struct UploadImageResult: Decodable {
    let data: ImageData

    struct ImageData: Decodable {
        let link: URL
    }
}
