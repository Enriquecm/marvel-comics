//
//  MCService.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

typealias MCHTTPHeaders = [String: String]
typealias MCRequestResponse = ((MCResponse) -> Void)?

protocol MCServiceProtocol: class {
    init(serviceError: MCServiceErrorProtocol)
    func requestHttp(url: MCURLConvertible?, method: MCHTTPMethod, parameters: MCParameters?, encoding: MCParameterEncoding, headers: MCHTTPHeaders?, completion: MCRequestResponse)
}

protocol MCServiceErrorProtocol {
    func errorFrom(_ data: Data?) -> MCNetworkError?
}

final class MCService {

    private let serviceError: MCServiceErrorProtocol

    init(serviceError: MCServiceErrorProtocol) {
        self.serviceError = serviceError
    }

    private func req(url: String, method: MCHTTPMethod = .get, parameters: MCParameters? = nil, encoding: MCParameterEncoding, headers: MCHTTPHeaders? = nil) -> URLRequest? {

        guard let url = encoding.urlEncode(url, method: method, with: parameters) else { return nil }

        // URL
        var originalRequest = URLRequest(url: url)

        // Method
        originalRequest.httpMethod = method.rawValue

        // Headers
        for (key, value) in (headers ?? [:]) {
            originalRequest.addValue(value, forHTTPHeaderField: key)
        }

        // Encoding
        let encodedURLRequest = encoding.encode(originalRequest, with: parameters)

        return encodedURLRequest
    }

    private func perform(request: URLRequest, completion: MCRequestResponse) {
        MCLog(from: "REQUEST", title: "URL: \(request.url?.absoluteString ?? "NO URL!")")

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in

            let parsedError = self.parseError(data, response, error)

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            let mcResponse = MCResponse(statusCode: statusCode, data: data, error: parsedError, request: request, response: response)

            if let data = mcResponse.data {
                MCLog(from: "RESPONSE", title: "Data: \(String(data: data, encoding: .utf8) ?? "")")
            }

            if let error = mcResponse.error {
                MCLog(from: "REQ-ERROR", title: "\(error.message)")
            }
            completion?(mcResponse)
            }.resume()
    }
}

extension MCService: MCServiceProtocol {

    func requestHttp(url: MCURLConvertible?, method: MCHTTPMethod = .get, parameters: MCParameters? = nil, encoding: MCParameterEncoding = URLEncoding.customQueryString, headers: MCHTTPHeaders? = nil, completion: MCRequestResponse) {

        MCLog(from: "REQUEST", title: "Endpoint: \(url ?? "NO URL")")
        MCLog(from: "REQUEST", title: "Method: \(method)")
        MCLog(from: "REQUEST", title: "Body: \(parameters?.description ?? "No parameters")")

        guard let strURL = url?.asString() else {
            let error = MCNetworkError(message: "Missing information.")
            let mcResponse = MCResponse(statusCode: 500, data: nil, error: error)
            MCLog(from: "REQ-ERROR", title: "\(error.message)")
            completion?(mcResponse)
            return
        }

        guard let req = self.req(url: strURL, method: method, parameters: parameters, encoding: encoding, headers: headers) else {
            let error = MCNetworkError.unexpectedError(message: "The service is unavailable.")
            let mcResponse = MCResponse(statusCode: 500, data: nil, error: error)

            MCLog(from: "REQ-ERROR", title: "\(error.message)")
            completion?(mcResponse)
            return
        }

        perform(request: req, completion: completion)
    }
}

internal extension MCService {

    func parseError(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> MCNetworkError? {
        if let error = errorFrom(error) {
            return error
        }
        if let responseError = errorFrom(response, data) {
            return responseError
        }

        return nil
    }

    func errorFrom(_ error: Error?) -> MCNetworkError? {
        guard let nsError = error as NSError? else {
            return nil
        }

        let systemErrors = [NSURLErrorNotConnectedToInternet,
                            NSURLErrorUnknown]

        if systemErrors.contains(nsError.code) {
            return MCNetworkError.noConnection()
        } else if NSURLErrorTimedOut == nsError.code {
            return MCNetworkError.timedOut()
        } else {
            return MCNetworkError.unexpectedError(message: nsError.localizedDescription)
        }
    }

    func errorFrom(_ response: URLResponse?, _ data: Data?) -> MCNetworkError? {
        let range: ClosedRange<Int> = 200...299
        guard let response = response as? HTTPURLResponse,
            !range.contains(response.statusCode) else {
                return nil
        }

        if let error = serviceError.errorFrom(data) {
            return error
        } else {
            return MCNetworkError.unexpectedError(message: "A service error happened.")
        }
    }
}

protocol MCURLConvertible {
    func asString() -> String
    func asURL() throws -> URL
}

extension String: MCURLConvertible {

    func asString() -> String {
        return self
    }

    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw MCNetworkError.unexpectedError(message: "A service error happened.")
        }
        return url
    }
}

extension URL: MCURLConvertible {

    func asString() -> String {
        return self.absoluteString
    }

    func asURL() throws -> URL {
        return self
    }
}
