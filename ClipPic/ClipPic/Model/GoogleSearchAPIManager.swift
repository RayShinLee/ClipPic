//
//  SearchAPIManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/18.
//

import Foundation
import Alamofire

class GoogleSearchAPIManager {
    
    func getSeachImages(keyword: String, completion: @escaping ([ImageItem]?, Error?) -> Void) {
        let APIKey = "AIzaSyDONlVyEvDBRvyMhkrCtGXTLhz9w2zINUU"
        let cx = "0b1fca30b71f6f225"
        let url = "https://customsearch.googleapis.com/customsearch/v1?cx=\(cx)&q=\(keyword)&searchType=image&key=\(APIKey)"
        
        let request = AF.request(url)
        request.responseDecodable(of: GoogleSearchImageResponse.self) { (response) in
            print("===============================")
            print(String.init(data: response.data!, encoding: .utf8))
            
            switch response.result {
            case .success(let searchResponse):
                completion(searchResponse.items, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }

    }
}

struct GoogleSearchImageResponse: Codable {
    let items: [ImageItem]
}
