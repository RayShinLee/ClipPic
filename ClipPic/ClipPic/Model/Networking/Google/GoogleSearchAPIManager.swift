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
        let apiKey = "AIzaSyDONlVyEvDBRvyMhkrCtGXTLhz9w2zINUU"
        let apiCX = "0b1fca30b71f6f225"
        let baseURL = "https://customsearch.googleapis.com/customsearch/v1"
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.queryItems = [
            URLQueryItem(name: "cx", value: apiCX),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "searchType", value: "image")
        ]
        guard let url = urlComponent?.url else { return }
        
        let request = AF.request(url)
        request.responseDecodable(of: GoogleSearchImageResponse.self) { (response) in
            switch response.result {
            case .success(let searchResponse):
                completion(searchResponse.items, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }

    }
}
