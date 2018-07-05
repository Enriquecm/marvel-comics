//
//  MCParser.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

final class MCParser<T> where T: Decodable {

    func parse(from responseData: Data, with dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        let decoded = try decoder.decode(T.self, from: responseData)
        return decoded
    }

    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateHelper.shared.serviceDateFormatter
        return .formatted(dateFormatter)
    }
}
