//
//  MCModelCharacterDataContainer.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelCharacterDataContainer: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [MCModelCharacter]?
}
