//
//  MCModelSeriesSummary.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelSeriesSummary: Codable {
    var resourceURI: String?
    var name: String?
}

extension MCModelSeriesSummary: MCCharacterSummaryProtocol {
    var summaryName: String? {
        return name
    }
}
