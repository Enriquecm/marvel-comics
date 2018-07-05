//
//  MCModelCharacter.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelCharacter: Codable {
    var id: Int?
    var name: String?
    var _description: String?
    var thumbnail: MCModelImage?
    var comicList: MCModelComicList?
}
