//
//  MCModelComicList.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelComicList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [MCModelComicSummary]?
}
