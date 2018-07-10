//
//  MCApiKeys.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 09/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCApiKeys {
    var publicKey: String {
        return value(forAPIKeyName: "MARVEL_PUBLIC_KEY")
    }

    var privateKey: String {
        return value(forAPIKeyName: "MARVEL_PRIVATE_KEY")
    }

    internal func value(forAPIKeyName keyname: String) -> String {
        let filePath = Bundle.main.path(forResource: "apikeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
}
