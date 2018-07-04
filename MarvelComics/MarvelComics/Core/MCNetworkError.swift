//
//  MCNetworkError.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

final class MCNetworkError: Error {
    var statusCode: Int
    var message: String

    init(code: Int = -1, message: String? = nil) {
        self.statusCode = code
        self.message = message ?? "An unknown error happened."
    }

    static func unknownError() -> MCNetworkError {
        return MCNetworkError()
    }

    static func parseError() -> MCNetworkError {
        return MCNetworkError(code: -1001, message: "Internal server error.")
    }

    static func noConnection() -> MCNetworkError {
        return MCNetworkError(code: -1001, message: "No internet connection.")
    }

    static func timedOut() -> MCNetworkError {
        return MCNetworkError(message: "Service timeout.")
    }

    static func unexpectedError(message: String?) -> MCNetworkError {
        return MCNetworkError(message: message)
    }
}

