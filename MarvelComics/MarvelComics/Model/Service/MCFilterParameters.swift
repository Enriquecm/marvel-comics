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

    func parameters() -> MCParameters {
        return ["offset": offset, "limit": limit]
    }
}
