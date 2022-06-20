//
//  SerpAPIManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/19.
//

import Foundation
import Alamofire

class SerpAPIManager {
    
    func search(with imageURL: String, completion: @escaping ([SerpImage]?, Error?) -> Void) {
        let apiKey = "925652fbd9b1b4b1bc64073327d169cc245b8ac0a513dd35e943fffebadb0f64"
        let engine = "google_reverse_image"
        let mockURL = "https://school.appworks.tw/wp-content/uploads/2018/09/AppWorks-School-Logo-Orange.png"
        let url = "https://serpapi.com/search.json?engine=\(engine)&image_url=\(mockURL)&api_key=\(apiKey)"
        
        let request = AF.request(url)
        request.responseDecodable(of: SerpSearchResponse.self) { (response) in
            print("===============================")
            print(String.init(data: response.data!, encoding: .utf8))
            
            switch response.result {
            case .success(let searchResponse):
                completion(searchResponse.inlineImages, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

struct SerpSearchResponse: Decodable {
    let inlineImages: [SerpImage]
    
    enum CodingKeys: String, CodingKey {
        case inlineImages = "inline_images"
    }
}
