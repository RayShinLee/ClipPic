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
        //  let mockURL = "https://i.imgur.com/VEXRj5S.png"
        //  "https://school.appworks.tw/wp-content/uploads/2018/09/AppWorks-School-Logo-Orange.png"
//       let url = "https://serpapi.com/search.json?engine=\(engine)&image_url=\(imageURL)&api_key=\(apiKey)"
        
        let baseURL = "https://serpapi.com/search.json"
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.queryItems = [
            URLQueryItem(name: "engine", value: engine),
            URLQueryItem(name: "image_url", value: imageURL),
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        guard let url = urlComponent?.url else { return }
        
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
