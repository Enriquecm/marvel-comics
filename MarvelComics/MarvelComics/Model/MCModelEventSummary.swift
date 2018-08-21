//
//  MCModelEventSummary.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCModelEventSummary: Codable {
    var resourceURI: String?
    var name: String?
}

extension MCModelEventSummary: MCCharacterSummaryProtocol {
    var summaryName: String? {
        return name
    }
}
