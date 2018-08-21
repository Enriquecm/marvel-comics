//
//  MCServiceErrorHandling.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 04/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

struct MCServiceErrorHandling: MCServiceErrorProtocol {
    func errorFrom(_ data: Data?) -> MCNetworkError? {
        guard let data = data,
            let errorJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any],
            let errorcode = errorJSON?["code"] as? Int,
            let errorMessage = errorJSON?["status"] as? String else {
                return nil
        }
        return MCNetworkError(code: errorcode, message: errorMessage)
    }
}

