//
//  MCModelCharacter.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelCharacter {
    var id: Int?
    var name: String?
    var characterDescription: String?
    var thumbnail: MCModelImage?
    var comics: MCModelComicList?
    var stories: MCModelStoryList?
    var events: MCModelEventList?
    var series: MCModelSeriesList?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case characterDescription = "description"
        case thumbnail
        case comics
        case stories
        case events
        case series
    }
}

extension MCModelCharacter: Encodable {
    func encode(to encoder: Encoder) throws {
        var character = encoder.container(keyedBy: CodingKeys.self)
        try character.encodeIfPresent(id, forKey: .id)
        try character.encodeIfPresent(name, forKey: .name)
        try character.encodeIfPresent(characterDescription, forKey: .characterDescription)
        try character.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try character.encodeIfPresent(comics, forKey: .comics)
        try character.encodeIfPresent(stories, forKey: .stories)
        try character.encodeIfPresent(events, forKey: .events)
        try character.encodeIfPresent(series, forKey: .series)
    }
}

extension MCModelCharacter: Decodable {
    init(from decoder: Decoder) throws {
        let character = try decoder.container(keyedBy: CodingKeys.self)
        id = try character.decodeIfPresent(Int.self, forKey: .id)
        name = try character.decodeIfPresent(String.self, forKey: .name)
        characterDescription = try character.decodeIfPresent(String.self, forKey: .characterDescription)
        thumbnail = try character.decodeIfPresent(MCModelImage.self, forKey: .thumbnail)
        comics = try character.decodeIfPresent(MCModelComicList.self, forKey: .comics)
        stories = try character.decodeIfPresent(MCModelStoryList.self, forKey: .stories)
        events = try character.decodeIfPresent(MCModelEventList.self, forKey: .events)
        series = try character.decodeIfPresent(MCModelSeriesList.self, forKey: .series)
    }
}
