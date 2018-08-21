//
//  MCCoreUtils.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

func MCLog(from: String = "NONE", title: String, message: Any? = nil) {
    #if DEBUG
    print("[\(from)] - \(title)")
    if let message = message {
        print("[\(from)] - Message: \(String(describing: message))")
    }
    #endif
}
