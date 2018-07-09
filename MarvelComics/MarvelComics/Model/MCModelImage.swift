//
//  MCModelImage.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelImage {
    var path: String?
    var imageExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}

extension MCModelImage: Encodable {
    func encode(to encoder: Encoder) throws {
        var image = encoder.container(keyedBy: CodingKeys.self)
        try image.encodeIfPresent(path, forKey: .path)
        try image.encodeIfPresent(imageExtension, forKey: .imageExtension)
    }
}

extension MCModelImage: Decodable {
    init(from decoder: Decoder) throws {
        let image = try decoder.container(keyedBy: CodingKeys.self)
        path = try image.decodeIfPresent(String.self, forKey: .path)
        imageExtension = try image.decodeIfPresent(String.self, forKey: .imageExtension)
    }
}

extension MCModelImage {
    var completePath: String? {
        guard let path = path, let imageExtension = imageExtension else { return nil }
        return path + "." + imageExtension
    }
}
