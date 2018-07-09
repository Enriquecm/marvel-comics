//
//  DeadPool.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

protocol DeadPoolProtocol {
    init(service: MCServiceProtocol)

    func marvelCharacters(filterParameters: MCFilterParameters, completion: ((Data?, MCNetworkError?) -> Void)?)
    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?)
}

final class DeadPool: DeadPoolProtocol {

    private let urlServer = URL(string: "http://gateway.marvel.com/v1/public")
    private let currentService: MCServiceProtocol
    private let prKey = "813714b14e5d0629eb714d347ad46d7c28fe794e"
    private let apiKey = "4750aee883492ab9eb6d8dab536f2e53"

    init(service: MCServiceProtocol) {
        currentService = service
    }

    func marvelCharacters(filterParameters: MCFilterParameters, completion: ((Data?, MCNetworkError?) -> Void)?) {
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = calculateHash(forTs: timestamp, prKey: prKey, puKey: apiKey)
        var parameters: MCParameters = ["apikey": apiKey,
                                        "ts": timestamp,
                                        "hash": hash]
        parameters.merge(filterParameters.parameters()) { (_, new) in new }

        let endpoint = "/characters"
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?) {
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = calculateHash(forTs: timestamp, prKey: prKey, puKey: apiKey)
        let parameters: MCParameters = ["ts": timestamp,
                                        "apikey": apiKey,
                                        "hash": hash]

        let endpoint = "/characters/\(characterId)"
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    private func calculateHash(forTs ts: String, prKey: String, puKey: String) -> String {
        let hash = (ts + prKey + puKey).md5 ?? ""
        return hash
    }

    private func executeRequest(url: URL?, method: MCHTTPMethod, parameters: MCParameters? = nil, headers: MCHTTPHeaders? = nil, completion: ((Data?, MCNetworkError?) -> Void)?) {

        currentService.requestHttp(url: url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers) { response in

            guard let data = response.data, response.error == nil else {
                completion?(nil, response.error)
                return
            }

            completion?(data, nil)
        }
    }
}
