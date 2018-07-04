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

    func marvelCharacters(completion: ((Data?, MCNetworkError?) -> Void)?)
    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?)
}

final class DeadPool: DeadPoolProtocol {

    private let urlServer = URL(string: "https://gateway.marvel.com:443/v1/public")
    private let currentService: MCServiceProtocol
    private let apiKey = "API_KEY"

    init(service: MCServiceProtocol) {
        currentService = service
    }

    func marvelCharacters(completion: ((Data?, MCNetworkError?) -> Void)?) {
        let endpoint = "/characters"
        let parameters: MCParameters = ["api_key": apiKey]

        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?) {
        let endpoint = "/characters/\(characterId)"
        let parameters: MCParameters = ["api_key": apiKey]

        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
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
