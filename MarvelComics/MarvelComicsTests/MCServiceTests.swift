//
//  MCServiceTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MCServiceTests: XCTestCase {

    private var deadPool: DeadPoolProtocolMock!
    private var errorHandling: MCServiceErrorProtocol!

    override func setUp() {
        super.setUp()
        errorHandling = MCServiceErrorHandling()
        let service = MCServiceMock(serviceError: errorHandling)
        deadPool = DeadPoolMock(service: service)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCharacters() {
        deadPool.marvelCharacters(filterParameters: MCFilterParameters(offset: 0, limit: 20), completion: nil)
        XCTAssertTrue(deadPool.didRequestCharacters, "The request method should be called.")
    }

    func testCharacterWithId() {
        deadPool.marvelCharacter(withId: 10001, completion: nil)
        XCTAssertTrue(deadPool.didRequestCharacter, "The request method should be called.")
    }

    func testErrorHandling() {
        let errorCode: Int = 404
        let message: String = "We couldn\'t find that character"
        let jsonString = "{\"code\":\(errorCode),\"status\":\"\(message)\"}"

        let data = jsonString.data(using: .utf8)
        let error = errorHandling.errorFrom(data)
        XCTAssertEqual(error?.statusCode, errorCode, "The Status Code should be the same of the json object")
        XCTAssertEqual(error?.message, message, "The Message should be the same of the json object")
    }

    func testErrorHandlingForInvalidJson() {
        let jsonString = "[{\"code\":404,\"status\":\"We couldn\'t find that character\"}]"

        let data = jsonString.data(using: .utf8)
        let error = errorHandling.errorFrom(data)
        XCTAssertNil(error, "The Error object should be nil if the json is in incorrect format")
    }
}

private class MCServiceMock: MCServiceProtocol {
    private(set) var didRequest = false

    required init(serviceError: MCServiceErrorProtocol) { }

    func requestHttp(url: MCURLConvertible?, method: MCHTTPMethod, parameters: MCParameters?, encoding: MCParameterEncoding, headers: MCHTTPHeaders?, completion: MCRequestResponse) {
        didRequest = true
    }
}

protocol DeadPoolProtocolMock: DeadPoolProtocol {

    var didRequestCharacters: Bool { get set }
    var didRequestCharacter: Bool { get set }
}

private class DeadPoolMock: DeadPoolProtocolMock {

    var didRequestCharacters: Bool
    var didRequestCharacter: Bool
    private var service: MCServiceProtocol

    required init(service: MCServiceProtocol) {
        didRequestCharacters = false
        didRequestCharacter = false
        self.service = service
    }

    func marvelCharacters(filterParameters: MCFilterParameters, completion: ((Data?, MCNetworkError?) -> Void)?) {
        didRequestCharacters = true
        service.requestHttp(url: nil, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, completion: nil)
    }

    func marvelCharacter(withId characterId: Int, completion: ((Data?, MCNetworkError?) -> Void)?) {
        didRequestCharacter = true
        service.requestHttp(url: nil, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, completion: nil)
    }
}
