//
//  MCFilterParameters.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 07/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCFilterParameters {

    var offset: Int
    var limit: Int
    var nameStartsWith: String?

    init(offset: Int, limit: Int, nameStartsWith: String? = nil) {
        self.offset = offset
        self.limit = limit
        self.nameStartsWith = nameStartsWith
    }

    func parameters() -> MCParameters {
        var parameters: MCParameters = ["offset": offset, "limit": limit]
        if let name = nameStartsWith {
            parameters["nameStartsWith"] = name
        }
        return parameters
    }
}
