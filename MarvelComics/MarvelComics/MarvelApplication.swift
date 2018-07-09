//
//  MarvelApplication.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MarvelApplication: UIApplication {

    static var instance: MarvelApplication {
        return super.shared as! MarvelApplication
    }

    let router = MCRouter()
    let service: DeadPool = {
        let errorHandling = MCServiceErrorHandling()
        let mainService = MCService(serviceError: errorHandling)
        let deadPool = DeadPool(service: mainService)
        return deadPool
    }()

    let imageCache = MCImageCache()
}
