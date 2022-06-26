//
//  GoogleSearchImage.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import Foundation

struct GoogleSearchImageResponse: Decodable {
    let items: [ImageItem]
}

struct ImageItem: Decodable {
    let title: String
    let link: String
    let image: Image
}

struct Image: Decodable {
    let contextLink: String
    let thumbnailLink: String
    let thumbnailHeight: Float
    let thumbnailWidth: Float
}
