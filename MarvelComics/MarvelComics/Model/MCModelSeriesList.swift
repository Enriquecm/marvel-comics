//
//  MCModelSeriesList.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 07/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelSeriesList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [MCModelSeriesSummary]?
}
