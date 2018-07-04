//
//  MCResponse.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

final class MCResponse: CustomDebugStringConvertible, Equatable {

    let statusCode: Int
    let data: Data?
    var error: MCNetworkError?
    let request: URLRequest?
    let response: URLResponse?

    public init(statusCode: Int, data: Data?, error: MCNetworkError?, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
        self.request = request
        self.response = response
    }

    public var description: String {
        return "Status Code: \(statusCode), Data Length: \(data?.count ?? 0))"
    }

    public var debugDescription: String {
        return description
    }
}

func == (lhs: MCResponse, rhs: MCResponse) -> Bool {
    return lhs.statusCode == rhs.statusCode
        && lhs.data == rhs.data
        && lhs.response == rhs.response
}
