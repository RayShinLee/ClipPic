//
//  GoogleSearchImage.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/21.
//

import Foundation

struct ImageItem: Codable {
    let kind: Kind
    let title, htmlTitle: String
    let link: String
    let displayLink, snippet, htmlSnippet: String
    let mime, fileFormat: FileFormat
    let image: Image
}

enum FileFormat: String, Codable {
    case image = "image/"
}

struct Image: Codable {
    let contextLink: String
    let height, width, byteSize: Int
    let thumbnailLink: String
    let thumbnailHeight, thumbnailWidth: Int
}

enum Kind: String, Codable {
    case customsearchResult = "customsearch#result"
}
