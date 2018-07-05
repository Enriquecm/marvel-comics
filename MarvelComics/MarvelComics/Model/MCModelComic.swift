//
//  MCModelComic.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelComic {
    var id: Int?
    var digitalId: Int?
    var title: String?
    var comicDescription: String?
    var resourceURI: String?
    var thumbnail: MCModelImage?
    var images: [MCModelImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalId
        case title
        case comicDescription = "description"
        case resourceURI
        case thumbnail
        case images
    }
}

extension MCModelComic: Encodable {
    func encode(to encoder: Encoder) throws {
        var comic = encoder.container(keyedBy: CodingKeys.self)
        try comic.encodeIfPresent(id, forKey: .id)
        try comic.encodeIfPresent(digitalId, forKey: .digitalId)
        try comic.encodeIfPresent(title, forKey: .title)
        try comic.encodeIfPresent(comicDescription, forKey: .comicDescription)
        try comic.encodeIfPresent(resourceURI, forKey: .resourceURI)
        try comic.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try comic.encodeIfPresent(images, forKey: .images)
    }
}

extension MCModelComic: Decodable {
    init(from decoder: Decoder) throws {
        let comic = try decoder.container(keyedBy: CodingKeys.self)
        id = try comic.decodeIfPresent(Int.self, forKey: .id)
        digitalId = try comic.decodeIfPresent(Int.self, forKey: .digitalId)
        title = try comic.decodeIfPresent(String.self, forKey: .title)
        comicDescription = try comic.decodeIfPresent(String.self, forKey: .comicDescription)
        resourceURI = try comic.decodeIfPresent(String.self, forKey: .resourceURI)
        thumbnail = try comic.decodeIfPresent(MCModelImage.self, forKey: .thumbnail)
        images = try comic.decodeIfPresent([MCModelImage].self, forKey: .images)
    }
}
